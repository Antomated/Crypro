//
//  CoingeckoEndpoint.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation

enum NetworkEndpoint {
    case allCoins
    case global
}

extension NetworkEndpoint {
    var baseURL: String { Constants.baseURL }

    var method: HTTPMethod {
        switch self {
        case .allCoins:
                .get
        case .global:
                .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .allCoins, .global:
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
        case .global:
            "/global"
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
        case .global:
            []
        }
    }
}
