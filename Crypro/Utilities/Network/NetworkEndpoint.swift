//
//  CoingeckoEndpoint.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation

enum NetworkEndpoint {
    case allCoins
    case globalData
    case coinDetails(id: String)
}

extension NetworkEndpoint {
    var baseURL: String { Constants.baseURL }

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
        case .coinDetails(let id):
            "/coins/\(id)"
        }
    }

    private var fullPath: String {
        Constants.apiPath + path
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .allCoins:
            [
                .init(name: "vs_currency", value: "usd"),
                .init(name: "order", value: "market_cap_desc"),
                .init(name: "per_page", value: "250"),
                .init(name: "page", value: "1"),
                .init(name: "sparkline", value: "true"),
                .init(name: "price_change_percentage", value: "24h")
            ]
        case .globalData:
            []
        case .coinDetails:
            [
                URLQueryItem(name: "localization", value: "false"),
                URLQueryItem(name: "tickers", value: "false"),
                URLQueryItem(name: "market_data", value: "false"),
                URLQueryItem(name: "community_data", value: "false"),
                URLQueryItem(name: "developer_data", value: "false"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
        }
    }
}
