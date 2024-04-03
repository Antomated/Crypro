//
//  HomeViewModel.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = []
    @Published var detailStatistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var selectedCoin: Coin?
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .rank

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    

    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        // TODO: Update portfolio
    }

    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        // TODO: Heptics
    }
}

// MARK: - Subscribers

private extension HomeViewModel {
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)

    }

    func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }

    func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }

        let lowerCasedText = text.lowercased()

        return coins.filter { coin in
            return coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
    }

    func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings: return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed: return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default: return coins
        }
    }

    // TODO: Refactor Statistics into enum?

    func mapGlobalMarketData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []

        guard let data else {
            return stats
        }

        let marketCap = Statistic(title: "Market Cap", value: data.marketCap,
                                  percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)

        let previosValue = portfolioCoins
            .map { $0.currentHoldingsValue / (1 + ($0.priceChangePercentage24H ?? 0) / 100) }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previosValue) / previosValue) * 100

        let portfolio = Statistic(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }

    func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { ($0.currentPrice ?? 0.0) > ($1.currentPrice ?? 0.0) }
        case .priceReversed:
            coins.sort { ($0.currentPrice ?? 0.0) < ($1.currentPrice ?? 0.0) }
        }
    }
}
