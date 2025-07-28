//
//  SearchResultViewController.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import UIKit

final class SearchResultViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(cell: StockCell.self)
        view.register(cell: ChipsCell.self)
        view.sectionHeaderHeight = UITableView.automaticDimension
        view.sectionHeaderTopPadding = 0
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var interactor: SearchResultInteractorInput?

    private var state: SearchResultModule.State = .firstAppear([]) {
        didSet {
            tableView.reloadData()
        }
    }

    var delegate: SearchResultDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.viewWillAppear()
    }
}

// MARK: - SearchResultViewInput
extension SearchResultViewController: SearchResultViewInput {
    func display(_ viewMdoel: UseCase.TapQuickAction.ViewModel) {
        delegate?.onTapQuickAction(with: viewMdoel.text)
    }
    
    func display(_ viewModel: UseCase.Load.ViewModel) {
        state = .firstAppear(viewModel.quickChips)
    }

    func display(_ viewModel: UseCase.Search.ViewModel) {
        state = .result(.init(sectionName: viewModel.sectionName, items: viewModel.stocks))
    }

    func display(_ viewMdoel: UseCase.Update) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard case let .firstAppear(sections) = state else {
            return 1
        }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .result(result) = state else {
            return 1
        }
        return result.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .result(let model):
            guard
                model.items.indices.contains(indexPath.row)
            else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(StockCell.self, for: indexPath)
            cell.make(with: model.items[indexPath.row])
            cell.onFavouriteTapped = { [weak self] in
                self?.interactor?.onTapFavourite(model.items[indexPath.row].subtitle)
            }
            return cell
        case .firstAppear(let sections):
            guard
                sections.indices.contains(indexPath.section)
            else { return UITableViewCell() }

            let cell = tableView.dequeueReusableCell(ChipsCell.self, for: indexPath)
            cell.configure(with: sections[indexPath.section].items)
            cell.onTap = { [weak self] item in
                self?.interactor?.onTapQuickAction(item)
            }
            return cell
        case .empty:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch state {
        case .result(let result):
            let view = SearchSectionView()
            view.configure(title: result.sectionName, buttonName: "show more")
            return view
        case .firstAppear(let items):
            guard items.indices.contains(section) else { return nil }
            let view = SearchSectionView()
            view.configure(title: items[section].name)
            return view
        case .empty:
            return nil
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        interactor?.didChangeSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - Private
private extension SearchResultViewController {
    func setupSubview() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
