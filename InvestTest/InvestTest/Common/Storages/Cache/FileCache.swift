//
//  FileCacheProtocol.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//
import Foundation
import CryptoKit

protocol FileCacheProtocol {
    func get<T: Codable>(key: String) -> T?
    func set<T: Codable>(object: T, key: String, expiry: LiveExpiryCache?)
    func remove(key: String) throws
    func removeAll() throws
    func removeExpired() throws
}

extension FileCacheProtocol {

    func get<T: Codable>(key: CustomStringConvertible) -> T? {
        return get(key: key.description)
    }

    func set<T: Codable>(object: T, key: CustomStringConvertible) {
        set(object: object, key: key.description, expiry: nil)
    }
}

protocol ComposableCache {
    func downstream(to cache: FileCacheProtocol?) -> Self
}


final class FileCache: FileCacheProtocol {

    private let label: String?
    private let name: String
    private let expiry: LiveExpiryCache
    private let keyConverter: CacheKeyConverter
    private let url: URL
    private let fileManager = FileManager.default
    private lazy var queue = DispatchQueue(label: "\(String(describing: self)).\(label ?? "access-queue")", attributes: .concurrent)

    init(label: String? = nil, name: String, expiry: LiveExpiryCache, keyConverter: CacheKeyConverter = BypassKeyConverter()) throws {
        self.label = label
        self.name = name
        self.expiry = expiry
        self.keyConverter = keyConverter
        let baseUrl = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        url = baseUrl.appendingPathComponent(name, isDirectory: true)
        try createDirectory(for: url)
    }

    func get<T: Codable>(key: String) -> T? {
        queue.sync {
            let convertedKey = keyConverter.convert(from: key)
            let url = fileUrl(for: convertedKey)
            guard let data = try? Data(contentsOf: url),
                let entity = try? JSONDecoder().decode(CacheEntity<T>.self, from: data), !entity.isExpired else {
                    return nil
            }
            return entity.object
        }
    }

    func set<T: Codable>(object: T, key: String, expiry: LiveExpiryCache?) {
        let convertedKey = keyConverter.convert(from: key)
        queue.async(flags: .barrier) {
            let url = self.fileUrl(for: convertedKey)
            let expiry = expiry ?? self.expiry
            if let data = try? JSONEncoder().encode(CacheEntity(object: object, ttl: expiry.ttl())) {
                try? data.write(to: url)
                try? self.fileManager.setAttributes([.modificationDate: expiry.ttl()], ofItemAtPath: url.path)
            }
        }
    }

    func remove(key: String) throws {
        let convertedKey = keyConverter.convert(from: key)
        let url = fileUrl(for: convertedKey)
        try queue.sync(flags: .barrier) {
            try fileManager.removeItem(atPath: url.path)
            try createDirectory(for: url)
        }
    }

    func removeAll() throws {
        try queue.sync(flags: .barrier) {
            try fileManager.removeItem(atPath: url.path)
            try createDirectory(for: url)
        }
    }

    func removeExpired() throws {
        try queue.sync(flags: .barrier) {
            let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey]
            let fileEnumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: resourceKeys, options: .skipsHiddenFiles)
            let referenceDate = Date()
            var urlToDelete: [URL] = []
            guard let objects = fileEnumerator?.allObjects as? [URL] else {
                return
            }

            for url in objects {
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory == true { continue }
                if let expiryDate = resourceValues.contentModificationDate, expiryDate.timeIntervalSince(referenceDate) <= 0 {
                    urlToDelete.append(url)
                }
            }

            for url in urlToDelete {
                try fileManager.removeItem(at: url)
            }
        }
    }

    private func fileName(for key: String) -> String {
        return key.hashed(.sha256).hexed()
    }

    private func fileUrl(for key: String) -> URL {
        return url.appendingPathComponent(fileName(for: key))
    }

    private func createDirectory(for url: URL) throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
    }

    private func setDirectoryAttributes(attributes: [FileAttributeKey: Any], at url: URL) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
    }
}
