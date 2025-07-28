//
//  Extensions+UITableView.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }

        return cell
    }

    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: cell))
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self, nibName: String) -> T {
        let identifier = String(describing: cellType)

        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            let nib = UINib(nibName: nibName, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
            return dequeueReusableCell(for: indexPath, cellType: cellType, nibName: nibName)
        }

        return cell
    }
}
