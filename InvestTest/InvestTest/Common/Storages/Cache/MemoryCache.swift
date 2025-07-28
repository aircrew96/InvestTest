
import Foundation

final class MemoryCache: FileCacheProtocol, ComposableCache {

    private let label: String?
    private let expiry: LiveExpiryCache
    private let keyConverter: CacheKeyConverter
    private var downstreamCache: FileCacheProtocol?
    private lazy var storage = NSCache<NSString, ExpirableCacheEntity>()
    private lazy var queue = DispatchQueue(label: "\(String(describing: self)).\(label ?? "access-queue")", attributes: .concurrent)

    init(label: String? = nil, objectLimit: Int = 0, expiry: LiveExpiryCache, keyConverter: CacheKeyConverter = BypassKeyConverter()) {
        self.label = label
        self.expiry = expiry
        self.keyConverter = keyConverter
        storage.countLimit = objectLimit
    }

    func downstream(to cache: FileCacheProtocol?) -> Self {
        downstreamCache = cache
        return self
    }

    func get<T: Codable>(key: String) -> T? {
        queue.sync {
            let convertedKey = keyConverter.convert(from: key)
            if let entity = storage.object(forKey: convertedKey as NSString) as? CacheEntity<T>, !entity.isExpired {
                return entity.object
            } else if let entity = storage.object(forKey: convertedKey as NSString) as? CacheEntity<T?>, !entity.isExpired {
                return entity.object
            } else if let downstreamCache = downstreamCache {
                return synchronize(key: key, with: downstreamCache)
            } else {
                return nil
            }
        }
    }

    func set<T: Codable>(object: T, key: String, expiry: LiveExpiryCache? = nil) {
        let convertedKey = keyConverter.convert(from: key)
        queue.async(flags: .barrier) {
            let entity = CacheEntity(object: object, ttl: (expiry ?? self.expiry).ttl())
            self.storage.setObject(entity, forKey: convertedKey as NSString)
            self.downstreamCache?.set(object: object, key: key, expiry: expiry)
        }
    }

    func remove(key: String) throws {
        let convertedKey = keyConverter.convert(from: key)
        try queue.sync(flags: .barrier) {
            storage.removeObject(forKey: convertedKey as NSString)
            try downstreamCache?.remove(key: key)
        }
    }

    func removeAll() throws {
        try queue.sync(flags: .barrier) {
            storage.removeAllObjects()
            try downstreamCache?.removeAll()
        }
    }

    func removeExpired() throws {
        try queue.sync(flags: .barrier) {
            try downstreamCache?.removeExpired()
        }
    }

    func synchronize<T: Codable>(key: String, with cache: FileCacheProtocol) -> T? {
        let convertedKey = keyConverter.convert(from: key)
        if let object: T = cache.get(key: key) {
            storage.setObject(CacheEntity(object: object, ttl: expiry.ttl()), forKey: convertedKey as NSString)
            return object
        } else {
            storage.removeObject(forKey: convertedKey as NSString)
            return nil
        }
    }
}
