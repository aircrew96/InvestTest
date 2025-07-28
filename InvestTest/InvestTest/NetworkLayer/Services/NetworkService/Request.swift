//
//  Request.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

enum Request {
    case stocks

    var path: String {
        switch self {
        case .stocks:
            return "api/stocks.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .stocks:
            return .get
        }
    }
}
