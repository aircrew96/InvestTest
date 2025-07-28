//
//  StoksListDataSource.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

enum Section: Hashable {
    case all
}

final class StoksListDataSource: UITableViewDiffableDataSource<Section, MainSceneModule.Item> {

    func reloadItems(_ data: [MainSceneModule.Item]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.all])
        snapshot.appendItems(data, toSection: .all)
        applySnapshotUsingReloadData(snapshot)
    }
}
