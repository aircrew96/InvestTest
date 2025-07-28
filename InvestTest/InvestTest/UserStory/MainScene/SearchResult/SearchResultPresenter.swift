//
//  SearchResultPresenter.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import Foundation

final class SearchResultPresenter: SearchResultPresenterInput {

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.alwaysShowsDecimalSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.locale = .current
        return formatter
    }()

    private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positiveSuffix = "%"
        formatter.locale = .current
        return formatter
    }()

    weak var view: SearchResultViewInput?

    func present(_ response: UseCase.Load.Response) {
        DispatchQueue.main.async {
            var actions: [SearchResultModule.QuickSectionModel] = [
                SearchResultModule.QuickSectionModel(name: "Popular requests", items: response.popularRequests)
            ]
            if !response.recentsRequests.isEmpty {
                actions.append(SearchResultModule.QuickSectionModel(name: "Recents requests", items: response.recentsRequests))
            }

            let viewModel = UseCase.Load.ViewModel(quickChips: actions)
            self.view?.display(viewModel)
        }
    }

    func present(_ response: UseCase.Search.Response) {
        DispatchQueue.main.async {
            let stocks = response.stocks.enumerated().map {
                let change = self.percentFormatter.string(from: $0.element.change as NSNumber) ?? ""
                let changePercent = self.percentFormatter.string(from: $0.element.changePercent as NSNumber) ?? ""
                let signSymbol = $0.element.isPositive ? "+" : ""
                return StockCell.ViewModel(
                    iconUrl: URL(string: $0.element.logo)!,
                    title: $0.element.symbol,
                    subtitle: $0.element.name,
                    price: self.currencyFormatter.string(from: $0.element.price as NSNumber) ?? "",
                    change: "\(signSymbol)\(change)" + "(\(changePercent))",
                    isFavorite: response.favouriteStocks.contains($0.element.name),
                    isProfit: $0.element.isPositive,
                    isIndication: $0.offset % 2 == 0
                )
            }
            let viewModel = UseCase.Search.ViewModel(sectionName: "Stocks", stocks: stocks)
            self.view?.display(viewModel)
        }
    }

    func present(_ response: UseCase.TapQuickAction.Response) {
        DispatchQueue.main.async {
            let viewModel = UseCase.TapQuickAction.ViewModel(text: response.text)
            self.view?.display(viewModel)
        }
    }

    func present(_ response: UseCase.Update) {
        DispatchQueue.main.async {
            self.view?.display(response)
        }
    }
}
