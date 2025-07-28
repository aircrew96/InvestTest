//
//  SearchResultInteractor.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import Foundation

final class SearchResultInteractor: SearchResultInteractorInput {

    private var quickActions: [UseCase.QuickSearch] = [
        .init(type: .popular, text: "Apple"),
        .init(type: .popular, text: "Amazon"),
        .init(type: .popular, text: "Google"),
        .init(type: .popular, text: "Tesla"),
        .init(type: .popular, text: "Microsoft")
    ]

    var presenter: SearchResultPresenterInput?

    @ParameterStorage(key: .recentsSearch, defaultValue: [])
    private var recentsSearch: [String]

    private var searchText: String = ""

    private let stockService: StockServiceProtocol

    init(stockService: StockServiceProtocol) {
        self.stockService = stockService
    }

    func viewWillAppear() {
        recentsSearch.forEach {
            quickActions.append(.init(type: .recent, text: $0))
        }
        let response = UseCase.Load.Response(
            popularRequests: quickActions.filter { $0.type == .popular }.map(\.text),
            recentsRequests: quickActions.filter{ $0.type == .recent }.map(\.text)
        )
        presenter?.present(response)
    }

    func didChangeSearchText(_ text: String) {
        searchText = text
        guard !text.isEmpty else {
            let response = UseCase.Load.Response(
                popularRequests: quickActions.filter { $0.type == .popular }.map(\.text),
                recentsRequests: quickActions.filter{ $0.type == .recent }.map(\.text)
            )
            presenter?.present(response)
            return
        }
        let filteredStocks = stockService.stocks.filter { $0.name.lowercased().contains(text.lowercased()) }
        let response = UseCase.Search.Response(
            favouriteStocks: stockService.favouriteStocks.map(\.name),
            stocks: filteredStocks
        )
        presenter?.present(response)
    }

    func onTapQuickAction(_ text: String) {
        searchText = text
        let response = UseCase.TapQuickAction.Response(text: text)
        presenter?.present(response)
    }

    func onTapFavourite(_ name: String) {
        guard let stock = stockService.stocks.first(where: { $0.name == name }) else { return }
        if stockService.favouriteStocks.contains(stock) {
            stockService.removeFavouriteStock(stock)
        } else {
            stockService.addFavouriteStock(stock)
        }
        let filteredStocks = stockService.stocks.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        let response = UseCase.Search.Response(
            favouriteStocks: stockService.favouriteStocks.map(\.name),
            stocks: filteredStocks
        )
        presenter?.present(response)
    }
}
