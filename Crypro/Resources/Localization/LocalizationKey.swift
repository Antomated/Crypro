//
//  LocalizationKey.swift
//  Crypro
//
//  Created by Beavean on 03.05.2024.
//

import Foundation

enum LocalizationKey: String {
    // MARK: - Home

    case portfolio
    case livePrices
    case searchByNameOrSymbol
    case coinRow
    case totalVolumeRow
    case priceRow

    // MARK: - Portfolio

    case portfolioTip
    case editPortfolio
    case amountHolding
    case saveButton
    case holdingsRow
    case btcDominance
    case activeCryptocurrencies
    case markets
    case totalIcos
    case zeroStatChange

    // MARK: - Edit Portfolio

    case marketCap
    case volume24h
    case portfolioValue
    case coinsInPortfolio
    case currentPrice
    case allTimeHigh
    case allTimeLow

    // MARK: - Details

    case sevenDaysChart
    case overview
    case additionalDetails
    case collapse
    case readMore
    case detailsCurrentPrice
    case marketCapitalization
    case rank
    case volume
    case high24h
    case low24h
    case priceChange24h
    case marketCapChange24h
    case blockTime
    case hashingAlgorithm
    case notAvailable
    case website
    case twitter
    case telegram
    case reddit

    // MARK: - Information

    case information
    case appDescription
    case visitGitHub
    case settings
    case darkTheme

    // MARK: - Network Errors

    case errorTitle
    case okButton
    case badResponseFromUrlError
    case retryLimitReachedError
    case unknownErrorOccurredError
    case invalidEndpointError
    case decodingResponseError

    // MARK: - Abbreviations

    case trillionAbbreviation
    case billionAbbreviation
    case millionAbbreviation
    case thousandAbbreviation

    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "\(rawValue)_comment")
    }
}
