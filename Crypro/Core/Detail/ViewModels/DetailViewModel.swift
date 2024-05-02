//
//  DetailViewModel.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//
// TODO: Url to enum

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    @Published var overviewStatistics = [Statistic]()
    @Published var additionalStatistics = [Statistic]()
    @Published var coin: Coin
    @Published var coinDescription: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?
    @Published var twitterURL: String?
    @Published var telegramURL: String?

    private let coinDetailService: CoinDetailsService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailsService(coin: coin)
        addSubscribers()
    }
}

// MARK: - ADD SUBSCRIBERS

private extension DetailViewModel {
    func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)

        coinDetailService.$coinDetails
            .sink { [weak self] coinDetail in
                self?.coinDescription = coinDetail?.readableDescription
                self?.websiteURL = coinDetail?.links?.homepage?.first
                self?.redditURL = coinDetail?.links?.subredditURL
                self?.twitterURL = coinDetail?.links?.twitterURL
                self?.telegramURL = coinDetail?.links?.telegramURL
            }
            .store(in: &cancellables)
    }
}

// MARK: - ADD SUBSCRIBERS METHODS

private extension DetailViewModel {
    func mapDataToStatistics(coinDetails: CoinDetails?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let overviewArray = createOverviewArray(coin: coin)
        let additionalArray = createAdditionalArray(coin: coin, coinDetails: coinDetails)
        return (overviewArray, additionalArray)
    }

    func createOverviewArray(coin: Coin) -> [Statistic] {
        var overviewArray: [Statistic] = []
        let price = (coin.currentPrice ?? 0.0).asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: LocalizationKey.detailsCurrentPrice.localizedString, value: price, percentageChange: pricePercentChange)

        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage =  coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: LocalizationKey.marketCapitalization.localizedString,
                                      value: marketCap, percentageChange: marketCapChangePercentage)

        let rank = "# \(coin.rank)"
        let rankStat = Statistic(title: LocalizationKey.rank.localizedString, value: rank)

        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: LocalizationKey.volume.localizedString, value: volume)

        overviewArray.append(contentsOf: [priceStat, marketCapStat, rankStat, volumeStat])
        return overviewArray
    }

    func createAdditionalArray(coin: Coin, coinDetails: CoinDetails?) -> [Statistic] {
        var additionalArray: [Statistic] = []
        let hight = coin.high24H?.asCurrencyWith6Decimals() ?? LocalizationKey.notAvailable.localizedString
        let hightStat = Statistic(title: LocalizationKey.high24h.localizedString, value: hight)

        let low = coin.low24H?.asCurrencyWith6Decimals() ?? LocalizationKey.notAvailable.localizedString
        let lowStat = Statistic(title: LocalizationKey.low24h.localizedString, value: low)

        let priceChange = coin.priceChange24?.asCurrencyWith6Decimals() ?? LocalizationKey.notAvailable.localizedString
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: LocalizationKey.priceChange24h.localizedString, value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage =  coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: LocalizationKey.marketCapChange24h.localizedString, value: marketCapChange, percentageChange: marketCapChangePercentage)

        let blockTime = coinDetails?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? LocalizationKey.notAvailable.localizedString : "\(blockTime)"
        let blockStat = Statistic(title: LocalizationKey.blockTime.localizedString, value: blockTimeString)

        let hashing = coinDetails?.hashingAlgorithm ?? LocalizationKey.notAvailable.localizedString
        let hashingStat = Statistic(title: LocalizationKey.hashingAlgorithm.localizedString, value: hashing)

        additionalArray.append(contentsOf: [hightStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat])
        return additionalArray
    }
}
