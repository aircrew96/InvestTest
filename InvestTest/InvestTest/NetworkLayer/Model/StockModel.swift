//
//  StockModel.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 18.07.2025.
//

import Foundation

struct StockModel: Decodable {
    let symbol: String
    let name: String
    let price: Decimal
    let change: Decimal
    let changePercent: Double
    let logo: String
}
