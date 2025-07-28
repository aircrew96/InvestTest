//
//  MainSceneInteractor.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

final class MainSceneInteractor: MainSceneInteractorInput {

    private var selectedSection: UseCase.Section = .all
    private var allStocks: [StockModel] = []

    var presenter: MainScenePresenterInput?
    @ParameterStorage(key: .recentsSearch, defaultValue: [])
    private var recentsSearch: [String]
    private let stockService: StockServiceProtocol

    init(stockService: StockServiceProtocol) {
        self.stockService = stockService
    }

    func load() {
        Task {
            do {
                let allStocks = try await stockService.requestAllStocks()
                self.allStocks = allStocks
                let response = UseCase.UpdateForm.Response(
                    items: allStocks,
                    favourites: stockService.requestFavouriteStocks().map(\.name)
                )
                presenter?.present(response)
            } catch {
                print(error)
            }
        }
    }

    func onTapSection(at index: Int) {
        guard let section = UseCase.Section(rawValue: index) else { return }
        selectedSection = section
        let favouriteStocks = stockService.requestFavouriteStocks()
        let response = UseCase.UpdateForm.Response(
            items: selectedSection == .favourites ? favouriteStocks : allStocks,
            favourites: favouriteStocks.map(\.name)
        )
        presenter?.present(response)
    }

    func onTapSelectFavourite(name: String) {
        guard let stock = allStocks.first(where: { $0.name == name }) else { return }
        var favouriteStocks = stockService.requestFavouriteStocks()
        if favouriteStocks.contains(where: { $0.name == name }) {
            stockService.removeFavouriteStock(stock)
            favouriteStocks.removeAll(where: { $0 == stock })
        } else {
            stockService.addFavouriteStock(stock)
            favouriteStocks.append(stock)
        }
        let response = UseCase.UpdateForm.Response(
            items: selectedSection == .favourites ? favouriteStocks : allStocks,
            favourites: favouriteStocks.map(\.name)
        )
        presenter?.present(response)
    }

    func onTapSearchButton(_ currentRequest: String) {
        guard !currentRequest.isEmpty, !recentsSearch.contains(currentRequest) else { return }
        recentsSearch.append(currentRequest)
    }
}
