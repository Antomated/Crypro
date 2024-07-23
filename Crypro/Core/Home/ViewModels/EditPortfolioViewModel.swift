//
//  EditPortfolioViewModel.swift
//  Crypro
//
//  Created by Antomated on 23.07.2024.
//

import Foundation
import Combine

final class EditPortfolioViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var detailStatistics: [Statistic] = []
    @Published var allCoins: [Coin]
    @Published var portfolioCoins: [Coin] = []
    // TODO: remove sort option
    @Published var sortOption: SortOption = .rank
    let selectedCoinState: SelectedCoinState
    private let portfolioDataService: PortfolioDataService
    private var cancellables = Set<AnyCancellable>()

    init(
        sharedState: SelectedCoinState,
        portfolioDataService: PortfolioDataService = PortfolioDataService(),
        allCoins: [Coin]
    ) {
        self.selectedCoinState = sharedState
        self.allCoins = allCoins
        self.portfolioDataService = portfolioDataService
        addSubscribers()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func addSubscribers() {
        selectedCoinState.$selectedCoin
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
                self.portfolioCoins = self.sortedPortfolioCoins(coins)
            }
            .store(in: &cancellables)
    }
}

private extension EditPortfolioViewModel {
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

    func filterAndSortCoins(_ coins: [Coin], query: String, sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(coins, filterQuery: query)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
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
}
