//
//  PortfolioTransactionViewModel.swift
//  Crypro
//
//  Created by Antomated on 23.07.2024.
//

import Foundation
import Combine

final class PortfolioTransactionViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var detailStatistics: [Statistic] = []
    let sharedState: SelectedCoinState
    private let portfolioDataService: PortfolioDataService
    private var cancellables = Set<AnyCancellable>()

    init(sharedState: SelectedCoinState, portfolioDataService: PortfolioDataService = PortfolioDataService()) {
        self.sharedState = sharedState
        self.portfolioDataService = portfolioDataService
        addSubscribers()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func addSubscribers() {
        sharedState.$selectedCoin
            .map(getCoinDetailStatistics)
            .sink { [weak self] stats in
                guard let self else { return }
                detailStatistics = stats
            }
            .store(in: &cancellables)
    }
}

private extension PortfolioTransactionViewModel {
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
}
