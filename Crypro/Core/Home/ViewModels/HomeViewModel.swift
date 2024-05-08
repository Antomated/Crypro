//
//  HomeViewModel.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = []
    @Published var detailStatistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var selectedCoin: Coin?
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .rank
    @Published var showLaunchView = true

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()

    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.triggerNotification(ofType: .success)
    }
}

// MARK: - Subscribers

private extension HomeViewModel {
    func addSubscribers() {

        coinDataService.$allCoins
            .combineLatest(marketDataService.$marketData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allCoins, marketData in
                guard let self, !allCoins.isEmpty, let marketData else { return }
                self.allCoins = allCoins
                self.statistics = self.mapGlobalMarketData(data: marketData, portfolioCoins: self.portfolioCoins)
                self.showLaunchView = false
            }
            .store(in: &cancellables)

        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                allCoins = coins
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)

        $selectedCoin
            .map(getCoinDetailStatistics)
            .sink { [weak self] stats in
                guard let self else { return }
                detailStatistics = stats
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                guard let self else { return }
                statistics = stats
                isLoading = false
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
            coin.name.lowercased().contains(lowerCasedText) ||
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

    func mapGlobalMarketData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []

        guard let data else {
            return stats
        }

        let marketCap = Statistic(title: LocalizationKey.marketCap.localizedString,
                                  value: data.marketCap,
                                  percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: LocalizationKey.volume24h.localizedString, value: data.volume)
        let btcDominance = Statistic(title: LocalizationKey.btcDominance.localizedString, value: data.btcDominance)

        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)

        let previousValue = portfolioCoins
            .map { $0.currentHoldingsValue / (1 + ($0.priceChangePercentage24H ?? 0) / 100) }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = Statistic(
            title: LocalizationKey.portfolioValue.localizedString,
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }

    func getCoinDetailStatistics(coin: Coin?) -> [Statistic] {
        guard let coin else { return [] }
        return [
            Statistic(title: LocalizationKey.marketCap.localizedString + ":",
                      value: coin.marketCap?.formattedWithAbbreviations() ?? ""),
            Statistic(title: LocalizationKey.currentPrice.localizedString + ":",
                      value: (coin.currentPrice ?? 0.0).formattedWithAbbreviations()),
            Statistic(title: LocalizationKey.allTimeHigh.localizedString + ":",
                      value: coin.ath?.formattedWithAbbreviations() ?? ""),
            Statistic(title: LocalizationKey.allTimeLow.localizedString + ":",
                      value: coin.atl?.formattedWithAbbreviations() ?? "")
        ]
    }

    func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allCoins
            .compactMap { coin in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
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
