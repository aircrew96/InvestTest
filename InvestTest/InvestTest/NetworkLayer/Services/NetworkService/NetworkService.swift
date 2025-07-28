//
//  NetworkService.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

import UIKit

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: Request, for map: T.Type) async throws -> T
    func request(_ request: Request) async throws -> (Data, HTTPURLResponse)
}

final class NetworkService: NetworkServiceProtocol {
    fileprivate enum RequestError: Error {
        case invalidUrl
        case invalidStatus
    }

    private let baseUrl: String = "https://mustdev.ru/"

    private lazy var session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    func request<T: Decodable>(_ request: Request, for map: T.Type) async throws -> T {
        guard let url = url(with: request.path) else {
            throw RequestError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let body = try body(request) {
            urlRequest.httpBody = body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await session.data(for: urlRequest)
        guard 
            let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else { throw RequestError.invalidStatus }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func request(_ request: Request) async throws -> (Data, HTTPURLResponse) {
        guard let url = url(with: request.path) else {
            throw RequestError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let body = try body(request) {
            urlRequest.httpBody = body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await session.data(for: urlRequest)
        guard 
            let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else { throw RequestError.invalidStatus }

        return (data, httpResponse)
    }


    private func body(_ request: Request) throws -> Data? {
        return nil
    }

    private func url(with path: String) -> URL? {
        URL(string: baseUrl + path)
    }
}
