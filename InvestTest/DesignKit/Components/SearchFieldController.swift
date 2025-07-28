//
//  SearchFieldController.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

public final class SearchFieldController: UISearchController {
    private let _searchBar = SearchBar()

    public override var searchBar: UISearchBar {
        return _searchBar
    }
}
