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
    @Published var facebookURL: String?

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
                self?.twitterURL = coinDetail?.links?.twitterScreenName
                self?.telegramURL = coinDetail?.links?.telegramChannelIdentifier
                self?.facebookURL = coinDetail?.links?.facebookUsername
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
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)

        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage =  coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChangePercentage)

        let rank = "# \(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)

        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)

        overviewArray.append(contentsOf: [priceStat, marketCapStat, rankStat, volumeStat])
        return overviewArray
    }

    func createAdditionalArray(coin: Coin, coinDetails: CoinDetails?) -> [Statistic] {
        var additionalArray: [Statistic] = []
        let hight = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let hightStat = Statistic(title: "24H Hight", value: hight)

        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24H Low", value: low)

        let priceChange = coin.priceChange24?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage =  coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercentage)

        let blockTime = coinDetails?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)

        let hashing = coinDetails?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)

        additionalArray.append(contentsOf: [hightStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat])
        return additionalArray
    }
}
