//
//  MarketData.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import Foundation

struct GlobalData: Decodable {
    let data: MarketData
}

struct MarketData: Decodable {
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    var marketCap: String {
        guard let item = totalMarketCap.first(where: { $0.key == "usd" }) else { return "" }
        return "$" + item.value.formattedWithAbbreviations()
    }

    var volume: String {
        guard let item = totalVolume.first(where: { $0.key == "usd" }) else { return "" }
        return "$" + item.value.formattedWithAbbreviations()
    }

    var btcDominance: String {
        guard let item = marketCapPercentage.first(where: { $0.key == "btc" }) else { return "" }
        return item.value.asPercentString()
    }
}
