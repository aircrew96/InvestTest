//
//  ImageCacheService.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

protocol ImageCacheServiceProtocol {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage?, for url: URL)
    func deleteImage(for url: URL)
    func clearCache()
}

final class ImageCacheService {
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = countLimit
        return cache
    }()

    let countLimit: Int

    /// Инициализатор
    /// - Parameter countLimit: Кол-во объектов в хранилище
    init(countLimit: Int = 40) {
        self.countLimit = countLimit
    }
}

// MARK: - PhotoCacheProtocol
extension ImageCacheService: ImageCacheServiceProtocol {
    func getImage(for url: URL) -> UIImage? {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }

    func saveImage(_ image: UIImage?, for url: URL) {
        guard
            let image = image
        else {
            return deleteImage(for: url)
        }
        imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }

    func deleteImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
    }

    func clearCache() {
        imageCache.removeAllObjects()
    }
}

