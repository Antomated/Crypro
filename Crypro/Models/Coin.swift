//
//  Coin.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Foundation

struct Coin: Decodable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: Sparkline?
    let priceChangePercentage24HInCurrency: Double?
    var currentHoldings: Double?

    mutating func updateHoldings(amount: Double) {
        currentHoldings = amount
    }

    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * (currentPrice ?? 0)
    }

    var formattedCurrentHoldings: String {
        guard let holdings = currentHoldings else { return "0" }
        return holdings > 1_000_000 ? holdings.formattedWithAbbreviations() : holdings.asNumberString()
    }

    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}
