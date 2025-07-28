//
//  SearchResultModule.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

protocol SearchResultInteractorInput {
    typealias UseCase = SearchResultModule.UseCase

    func viewWillAppear()
    func didChangeSearchText(_ text: String)
    func onTapQuickAction(_ text: String)
    func onTapFavourite(_ name: String)
}

protocol SearchResultPresenterInput {
    typealias UseCase = SearchResultModule.UseCase

    func present(_ response: UseCase.Load.Response)
    func present(_ response: UseCase.Search.Response)
    func present(_ response: UseCase.TapQuickAction.Response)
    func present(_ response: UseCase.Update)
}

protocol SearchResultViewInput: AnyObject {
    typealias UseCase = SearchResultModule.UseCase
    
    func display(_ viewModel: UseCase.Load.ViewModel)
    func display(_ viewModel: UseCase.Search.ViewModel)
    func display(_ viewMdoel: UseCase.TapQuickAction.ViewModel)
    func display(_ viewMdoel: UseCase.Update)
}

enum SearchResultModule {
    enum UseCase {
        enum Load {
            struct Response {
                let popularRequests: [String]
                let recentsRequests: [String]
            }
            struct ViewModel {
                let quickChips: [QuickSectionModel]
            }
        }

        enum Search {
            struct Response {
                let favouriteStocks: [String]
                let stocks: [StockModel]
            }
            struct ViewModel {
                let sectionName: String
                let stocks: [StockCell.ViewModel]
            }
        }

        enum TapQuickAction {
            struct Response {
                let text: String
            }
            struct ViewModel {
                let text: String
            }
        }
        struct QuickSearch {
            enum `Type` {
                case popular
                case recent
            }
            let type: `Type`
            let text: String
        }

        struct Update {

        }
    }

    struct QuickSectionModel {
        let name: String
        let items: [String]
    }

    enum State {
        case firstAppear([QuickSectionModel])
        case result(ResultModel)
        case empty
    }

    struct ResultModel: Hashable {
        let sectionName: String
        let items: [StockCell.ViewModel]
    }
}
