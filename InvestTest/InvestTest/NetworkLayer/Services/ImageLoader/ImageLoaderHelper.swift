//
//  ImageLoaderHelper.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

/// Интерфейс хелпера для загрузки картинок
protocol ImageLoaderHelperProtocol {

    /// Загрузить картинку по переданному пути
    ///  - Parameters:
    ///   - url: URL
    ///   - completion: Блок, обрабатывающий выполнение запроса
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)

    /// Загрузить картинку по переданному пути
    ///  - Parameters:
    ///   - url: URL
    ///   - completion: Блок, обрабатывающий выполнение запроса
    func loadImage(url: URL, completion: @escaping (UIImage) -> Void)
}

/// Хелпер для загрузки картинок
final class ImageLoaderHelper: ImageLoaderHelperProtocol {

    private let imageService: ImageLoaderServiceProtocol
    private let cacheService: ImageCacheServiceProtocol

    /// Инициализатор
    /// - Parameter imageService: Сервисный слой для загрузки картинки
    /// - Parameter cacheService: Кеш сервис
    init(
        imageService: ImageLoaderServiceProtocol = ImageLoaderService(),
        cacheService: ImageCacheServiceProtocol = ImageCacheService()
    ) {
        self.imageService = imageService
        self.cacheService = cacheService
    }

    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        loadImage(url: url, completion: completion)
    }

    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        if let image = cacheService.getImage(for: url) {
            completion(image)
        }
        imageService.loadImage(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self?.cacheService.saveImage(image, for: url)
                completion(image)
            case .failure(let error):
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }
}
