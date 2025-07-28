//
//  SearchResultAssembly.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import UIKit

final class SearchResultAssembly {
    static func make(stockService: StockServiceProtocol) -> SearchResultViewController {
        let view = SearchResultViewController()
        let interactor = SearchResultInteractor(stockService: stockService)
        let presenter = SearchResultPresenter()
        interactor.presenter = presenter
        presenter.view = view
        view.interactor = interactor
        return view
    }
}
