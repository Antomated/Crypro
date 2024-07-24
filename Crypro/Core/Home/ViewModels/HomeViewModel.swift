//
//  HomeViewModel.swift
//  Crypro
//
//  Created by Antomated on 02.04.2024.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticPair] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var error: IdentifiableError?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .rank
    @Published var showLaunchView: Bool = false
    @Published var isLoading: Bool = false
    @Published var selectedCoin: Coin?
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
        setupLoadingSubscriber()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func deleteCoin(_ coin: Coin) {
        updatePortfolio(coin: coin, amount: 0)
    }

    func reloadData() {
        guard isLoading == false else { return }
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
            .combineLatest($sortOption)
            .map { coins, sortOption in
                self.filterAndSortCoins(coins, query: self.searchText, sortOption: sortOption)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sortedCoins in
                guard let self else { return }
                allCoins = sortedCoins
                isLoading = false
            }
            .store(in: &cancellables)

        coinDataService.$allCoins
            .combineLatest($searchText, $sortOption)
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
            .sink { [weak self] coins in
                guard let self else { return }
                self.portfolioCoins = self.sortedPortfolioCoins(coins)
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalAndSecondaryMarketData)
            .sink { [weak self] stats in
                guard let self else { return }
                statistics = stats
                isLoading = false
            }
            .store(in: &cancellables)

        coinDataService.$error
            .merge(with: marketDataService.$error)
            .compactMap { $0?.errorDescription }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                guard let self else { return }
                error = IdentifiableError(message: errorMessage)
            })
            .store(in: &cancellables)
    }

    private func setupLoadingSubscriber() {
        $isLoading
            .flatMap { isLoading -> AnyPublisher<Bool, Never> in
                Just(isLoading)
                    .delay(for: .seconds(isLoading ? 0 : 2), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .assign(to: &$showLaunchView)
    }

    func filterAndSortCoins(_ coins: [Coin], query: String, sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(coins, filterQuery: query)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }

    func filterCoins(_ coins: [Coin], filterQuery: String) -> [Coin] {
        guard !filterQuery.isEmpty else {
            return coins
        }

        let lowerCasedText = filterQuery.lowercased()

        return coins.filter { coin in
            coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
    }

    func sortedPortfolioCoins(_ coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsDescending:
            coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            coins
        }
    }

    func mapGlobalAndSecondaryMarketData(data: MarketData?, portfolioCoins: [Coin]) -> [StatisticPair] {
        let topStats = mapGlobalMarketData(data: data, portfolioCoins: portfolioCoins)
        let bottomStats = mapSecondaryGlobalMarketData(data: data, portfolioCoins: portfolioCoins)
        return zip(topStats, bottomStats).map { StatisticPair(top: $0, bottom: $1) }
    }

    func mapGlobalMarketData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        guard let data else { return [] }
        var stats: [Statistic] = []

        let marketCap = Statistic(
            title: LocalizationKey.marketCap.localizedString,
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )

        let totalIcos = data.ongoingIcos + data.endedIcos
        let icoPercentageChange = totalIcos == 0 ? 0 : (Double(data.ongoingIcos) / Double(totalIcos)) * 100
        let icoStatistic = Statistic(
            title: LocalizationKey.totalIcos.localizedString,
            value: (data.endedIcos + data.ongoingIcos).formatted(),
            percentageChange: icoPercentageChange
        )

        let btcDominance = Statistic(
            title: LocalizationKey.btcDominance.localizedString,
            value: data.btcDominance
        )

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

        stats.append(contentsOf: [marketCap, icoStatistic, btcDominance, portfolio])
        return stats
    }

    func mapSecondaryGlobalMarketData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        guard let data else { return [] }
        var stats: [Statistic] = []

        let activeCryptocurrencies = Statistic(
            title: LocalizationKey.activeCryptocurrencies.localizedString,
            value: "\(data.activeCryptocurrencies)"
        )
        let markets = Statistic(
            title: LocalizationKey.markets.localizedString,
            value: "\(data.markets)"
        )

        let volume = Statistic(
            title: LocalizationKey.volume24h.localizedString,
            value: data.volume
        )

        let portfolioCoins = Statistic(
            title: LocalizationKey.coinsInPortfolio.localizedString,
            value: "\(portfolioCoins.count)"
        )

        stats.append(contentsOf: [markets, activeCryptocurrencies, volume, portfolioCoins])
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
        allCoins.compactMap { coin in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
            var updatedCoin = coin
            updatedCoin.updateHoldings(amount: entity.amount)
            return updatedCoin
        }
    }

    func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank:
            coins.sort { $0.rank < $1.rank }
        case .rankDescending:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { ($0.currentPrice ?? 0.0) > ($1.currentPrice ?? 0.0) }
        case .priceDescending:
            coins.sort { ($0.currentPrice ?? 0.0) < ($1.currentPrice ?? 0.0) }
        case .totalVolume:
            coins.sort { ($0.totalVolume ?? 0.0) > ($1.totalVolume ?? 0.0) }
        case .totalVolumeDescending:
            coins.sort { ($0.totalVolume ?? 0.0) < ($1.totalVolume ?? 0.0) }
        case .holdings, .holdingsDescending:
            return
        }
    }
}
