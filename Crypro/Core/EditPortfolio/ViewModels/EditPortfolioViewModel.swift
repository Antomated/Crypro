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
    @Published var portfolioCoins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    @Published var selectedCoin: Coin?
    private(set) var networkManager: NetworkServiceProtocol
    private let allCoins: [Coin]
    private let portfolioDataService: PortfolioDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let maxCurrentValue: Double = 100_000_000_000

    init(
        selectedCoin: Coin?,
        allCoins: [Coin],
        networkManager: NetworkServiceProtocol,
        portfolioDataService: PortfolioDataServiceProtocol
    ) {
        self.selectedCoin = selectedCoin
        self.allCoins = allCoins
        self.filteredCoins = allCoins
        self.networkManager = networkManager
        self.portfolioDataService = portfolioDataService
        addSubscribers()
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func formatQuantityText(_ text: String, currentValue: Double) -> String {
        var newText = text.replacingOccurrences(of: ",", with: ".")
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        newText = String(newText.unicodeScalars.filter { allowedCharacters.contains($0) })

        // Handle multiple dots
        let dotCount = newText.filter { $0 == "." }.count
        if dotCount > 1 {
            let integerPart = newText.prefix(while: { $0 != "." })
            let fractionalPart = newText.drop(while: { $0 != "." }).dropFirst().filter { $0 != "." }
            newText = String(integerPart) + "." + String(fractionalPart)
        }

        // Remove leading zeros, but allow "0."
        if newText.hasPrefix("0"), newText.count > 1, newText[newText.index(after: newText.startIndex)] != "." {
            newText = "0" + newText.drop(while: { $0 == "0" })
        }

        // Ensure string starts with "0" if it begins with a dot
        if newText.hasPrefix(".") {
            newText = "0" + newText
        }

        // Limit to 4 decimal places
        if let dotIndex = newText.firstIndex(of: ".") {
            let decimalPart = newText[dotIndex...]
            if decimalPart.count > 5 { // including the dot itself
                newText = String(newText.prefix(dotIndex.utf16Offset(in: newText) + 5))
            }
        }

        // Limit to 10,000,000 in value
        if let amount = Double(newText), currentValue > maxCurrentValue {
            newText = String(format: "%.4f", maxCurrentValue / (selectedCoin?.currentPrice ?? 1))
        }

        return newText
    }
}

private extension EditPortfolioViewModel {
    func addSubscribers() {
        $selectedCoin
            .map(getCoinDetailStatistics)
            .sink { [weak self] stats in
                guard let self else { return }
                detailStatistics = stats
            }
            .store(in: &cancellables)

        portfolioDataService.savedEntitiesPublisher
            .map { savedEntities in
                self.mapAllCoinsToPortfolioCoins(allCoins: self.allCoins, portfolioEntities: savedEntities)
            }
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
            }
            .store(in: &cancellables)

        $searchText
            .map { query in
                self.filterAndSortCoins(self.allCoins, query: query)
            }
            .sink { coins in
                self.filteredCoins = coins
                if let selectedCoin = self.selectedCoin, !coins.contains(where: { $0.id == selectedCoin.id }) {
                    self.selectedCoin = nil
                }
            }
            .store(in: &cancellables)
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

    func filterAndSortCoins(_ coins: [Coin], query: String) -> [Coin] {
        guard !query.isEmpty else { return coins }
        let lowerCasedText = query.lowercased()
        var updatedCoins = coins.filter { coin in
            coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
        updatedCoins.sort { $0.rank < $1.rank }
        return updatedCoins
    }
}
