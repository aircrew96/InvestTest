//
//  MainSceneViewController.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 18.07.2025.
//

import UIKit
import DesignKit

final class MainSceneViewController: UIViewController {

    private lazy var searchController: SearchFieldController = {
        let searchResultController = SearchResultAssembly.make(stockService: stockService)
        let controller = SearchFieldController(searchResultsController: searchResultController)
        searchResultController.delegate = self
        controller.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.showsSearchResultsController = true
        controller.searchResultsUpdater = searchResultController
        return controller
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.sectionHeaderHeight = UITableView.automaticDimension
        view.sectionHeaderTopPadding = 0
        view.separatorStyle = .none
        view.register(cell: StockCell.self)
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tabsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var sections: [String] = [
        Localization.Main.Section.stocks,
        Localization.Main.Section.favourite
    ]
    private var items: [MainSceneModule.Item] = [] {
        didSet {
            dataSource.reloadItems(items)
        }
    }
    private lazy var dataSource = configureDataSource()
    private var selectedIndex: Int = 0

    var interactor: MainSceneInteractorInput?

    private let stockService: StockServiceProtocol

    init(stockService: StockServiceProtocol) {
        self.stockService = stockService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchController()
        setupSubview()
        interactor?.load()
    }
}

// MARK: - MainSceneViewInput
extension MainSceneViewController: MainSceneViewInput {
    func display(_ viewModel: UseCase.UpdateForm.ViewModel) {
        self.items = viewModel.items
    }
}

extension MainSceneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TabsSection()
        header.setTabs(sections, activeIndex: selectedIndex)
        header.onTap = { [weak self] index in
            self?.selectedIndex = index
            self?.interactor?.onTapSection(at: index)
        }
        return header
    }
}

// MARK: - SearchResultDelegate
extension MainSceneViewController: SearchResultDelegate {
    func onTapQuickAction(with text: String) {
        searchController.searchBar.text = text
    }
}

// MARK: - UISearchControllerDelegate
extension MainSceneViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
        interactor?.onTapSearchButton(searchBar.text ?? "")
    }
}

// MARK: - UISearchControllerDelegate
extension MainSceneViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setImage(UIImage(systemName: "arrow.left"), for: .search, state: .normal)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchIconTap))
        tapGesture.cancelsTouchesInView = false

        let searchField = searchController.searchBar.searchTextField
        searchField.leftView?.isUserInteractionEnabled = true
        searchField.leftView?.addGestureRecognizer(tapGesture)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
    }

    @objc private func handleSearchIconTap() {
        searchController.isActive = false
    }
}

// MARK: - Private
private extension MainSceneViewController {
    func setupSubview() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchController.automaticallyShowsCancelButton = false
    }

    func configureDataSource() -> StoksListDataSource {
        let dataSource = StoksListDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(StockCell.self, for: indexPath)
                cell.make(with: item)
                cell.onFavouriteTapped = { [weak self] in
                    self?.interactor?.onTapSelectFavourite(name: item.subtitle)
                }
                return cell
            }
        )
        return dataSource
    }
}
