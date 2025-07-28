//
//  StockService.swift
//  AuthorizationTest
//
//  Created by Олег Ганяхин on 29.07.2025.
//

protocol StockServiceProtocol {
    var stocks: [StockModel] { get }
    var favouriteStocks: [StockModel] { get }

    func requestAllStocks() async throws -> [StockModel]
    func requestFavouriteStocks() -> [StockModel]
    func addFavouriteStock(_ stock: StockModel)
    func removeFavouriteStock(_ stock: StockModel)
}

final class StockService: StockServiceProtocol {
    var stocks: [StockModel] {
        _stocks
    }

    var favouriteStocks: [StockModel] {
        _favouriteStocks
    }

    private var _favouriteStocks: [StockModel] = []
    private var _stocks: [StockModel] = []

    private let apiService: NetworkServiceProtocol
    private let cacheService: FileCacheProtocol?

    init(apiService: NetworkServiceProtocol = NetworkService()) {
        self.apiService = apiService
        self.cacheService = try? FileCache(name: #file, expiry: .never)
    }

    func requestAllStocks() async throws -> [StockModel] {
        self._stocks = try await apiService.request(.stocks, for: [StockModel].self)
        return self._stocks
    }

    func requestFavouriteStocks() -> [StockModel] {
        guard let cacheService else { return [] }
        let stocks: [StockModel] = cacheService.get(key: FileManagerKey.favouriteStocks.rawValue) ?? []
        self._favouriteStocks = stocks
        return stocks
    }

    func addFavouriteStock(_ stock: StockModel) {
        guard let cacheService else { return }
        var allStocks: [StockModel] = cacheService.get(key: FileManagerKey.favouriteStocks.rawValue) ?? []
        allStocks.append(stock)
        self._favouriteStocks = allStocks
        cacheService.set(object: allStocks, key: FileManagerKey.favouriteStocks.rawValue)
    }

    func removeFavouriteStock(_ stock: StockModel) {
        guard let cacheService else { return }
        var allStocks: [StockModel] = cacheService.get(key: FileManagerKey.favouriteStocks.rawValue) ?? []
        allStocks.removeAll(where: { $0 == stock })
        self._favouriteStocks = allStocks
        cacheService.set(object: allStocks, key: FileManagerKey.favouriteStocks.rawValue)
    }
}
