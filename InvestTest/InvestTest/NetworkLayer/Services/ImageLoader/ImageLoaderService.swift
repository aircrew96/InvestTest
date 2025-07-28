//
//  ImageLoaderService.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

/// Протокол сервиса для загрузки картинок по URL
protocol ImageLoaderServiceProtocol {

    /// Отправить запрос на загрузку картинки
    ///  - Parameters:
    ///  - url: URL
    ///  - completion: Блок, обрабатывающий выполнение запроса
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

/// Сервис для загрузки картинок по URL
final class ImageLoaderService: ImageLoaderServiceProtocol {

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()

    /// Загружает данные для картинки и возвращает их, если получилось
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        DispatchQueue.global(qos: .utility).async {
            self.session.dataTask(with: url, completionHandler: { data, _ , error in
                guard
                    let data = data,
                    error == nil
                else {
                    if let error = error {
                        completionOnMain(.failure(error))
                    }
                    return
                }
                completionOnMain(.success(data))
            }).resume()
        }
    }
}
