//
//  CacheKeyConverter.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

import Foundation

protocol CacheKeyConverter {
    func convert(from value: String) -> String
}

final class BypassKeyConverter: CacheKeyConverter {

    init() {}

    func convert(from value: String) -> String {
        return value
    }
}
