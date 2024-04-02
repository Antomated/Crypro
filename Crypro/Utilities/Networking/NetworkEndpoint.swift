//
//  CoingeckoEndpoint.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation

enum NetworkEndpoint {
    case allCoins

    var baseURL: String { Constants.baseURL }

    var path: String {
        switch self {
        case .allCoins: return Constants.apiPath + "/coins/markets"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allCoins: return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .allCoins:
            return ["x-cg-demo-api-key": Constants.apiKey]
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .allCoins:
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "250"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "sparkline", value: "true"),
                URLQueryItem(name: "price_change_percentage", value: "24h")
            ]
        }
    }

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
