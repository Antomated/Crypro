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
    let currentHoldings: Double?

    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id,
                    symbol: symbol,
                    name: name,
                    image: image,
                    currentPrice: currentPrice,
                    marketCap: marketCap,
                    marketCapRank: marketCapRank,
                    fullyDilutedValuation: fullyDilutedValuation,
                    totalVolume: totalVolume,
                    high24H: high24H,
                    low24H: low24H,
                    priceChange24: priceChange24,
                    priceChangePercentage24H: priceChangePercentage24H,
                    marketCapChange24H: marketCapChange24H,
                    marketCapChangePercentage24H: marketCapChangePercentage24H,
                    circulatingSupply: circulatingSupply,
                    totalSupply: totalSupply,
                    maxSupply: maxSupply,
                    ath: ath,
                    athChangePercentage: ath,
                    athDate: athDate,
                    atl: atl,
                    atlChangePercentage: atlChangePercentage,
                    atlDate: atlDate,
                    lastUpdated: lastUpdated,
                    sparklineIn7D: sparklineIn7D,
                    priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
                    currentHoldings: amount)
    }

    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * (currentPrice ?? 0)
    }

    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}
