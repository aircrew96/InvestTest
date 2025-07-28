//
//  MainSceneAssembly.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

final class MainSceneAssembly {
    static func make() -> UIViewController {
        let service = StockService()
        let view = MainSceneViewController(stockService: service)
        let interactor = MainSceneInteractor(stockService: service)
        let presenter = MainScenePresenter()
        interactor.presenter = presenter
        presenter.view = view
        view.interactor = interactor
        return view
    }
}
