//
//  MainSceneModule.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

protocol MainSceneInteractorInput {
    typealias UseCase = MainSceneModule.UseCase

    func load()
    func onTapSection(at index: Int)
    func onTapSelectFavourite(name: String)
    func onTapSearchButton(_ currentRequest: String)
}

protocol MainScenePresenterInput {
    typealias UseCase = MainSceneModule.UseCase

    func present(_ response: UseCase.UpdateForm.Response)
}

protocol MainSceneViewInput: AnyObject {
    typealias UseCase = MainSceneModule.UseCase

    func display(_ viewModel: UseCase.UpdateForm.ViewModel)
}

enum MainSceneModule {
    enum UseCase {
        enum UpdateForm {
            struct Response {
                let items: [StockModel]
                let favourites: [String]
            }

            struct ViewModel {
                let items: [Item]
            }
        }

        enum Section: Int {
            case all = 0
            case favourites = 1
        }
    }

    typealias Item = StockCell.ViewModel
}
