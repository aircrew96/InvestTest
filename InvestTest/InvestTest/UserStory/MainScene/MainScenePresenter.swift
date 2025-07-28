//
//  MainScenePresenter.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import Foundation

final class MainScenePresenter: MainScenePresenterInput {

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

    weak var view: MainSceneViewInput?

    func present(_ response: UseCase.UpdateForm.Response) {
        DispatchQueue.main.async {
            let items = response.items.enumerated().map {
                let change = self.percentFormatter.string(from: $0.element.change as NSNumber) ?? ""
                let changePercent = self.percentFormatter.string(from: $0.element.changePercent as NSNumber) ?? ""
                let signSymbol = $0.element.isPositive ? " + " : ""
                return StockCell.ViewModel(
                    iconUrl: URL(string: $0.element.logo)!,
                    title: $0.element.symbol,
                    subtitle: $0.element.name,
                    price: self.currencyFormatter.string(from: $0.element.price as NSNumber) ?? "",
                    change: "\(signSymbol)\(change)" + "(\(changePercent))",
                    isFavorite: response.favourites.contains($0.element.name),
                    isProfit: $0.element.isPositive,
                    isIndication: $0.offset % 2 == 0
                )
            }
            let viewModel = UseCase.UpdateForm.ViewModel(items: items)
            self.view?.display(viewModel)
        }
    }
}
