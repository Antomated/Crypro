//
//  CoingeckoEndpoint.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Foundation

enum CoingeckoEndpoint {
    case allCoins
    case globalData
    case coinDetails(id: String)
}

// MARK: - Computed properties

extension CoingeckoEndpoint {
    var baseURL: String { Constants.apiBaseURL }

    var method: HTTPMethod {
        switch self {
        case .allCoins, .globalData, .coinDetails:
                .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .allCoins, .globalData, .coinDetails:
            ["x-cg-demo-api-key": Constants.apiKey]
        }
    }

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = fullPath
        components?.queryItems = queryItems
        return components?.url
    }

    private var path: String {
        switch self {
        case .allCoins:
            "/coins/markets"
        case .globalData:
            "/global"
        case let .coinDetails(id):
            "/coins/\(id)"
        }
    }

    private var fullPath: String {
        Constants.apiPath + path
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .allCoins:
            [.init(name: "vs_currency", value: "usd"),
             .init(name: "order", value: "market_cap_desc"),
             .init(name: "per_page", value: "250"),
             .init(name: "page", value: "1"),
             .init(name: "sparkline", value: "true"),
             .init(name: "price_change_percentage", value: "24h")]
        case .globalData:
            []
        case .coinDetails:
            [.init(name: "localization", value: "false"),
             .init(name: "tickers", value: "false"),
             .init(name: "market_data", value: "false"),
             .init(name: "community_data", value: "false"),
             .init(name: "developer_data", value: "false"),
             .init(name: "sparkline", value: "false")]
        }
    }
}
