//
//  CoinDetail.swift
//  Crypro
//
//  Created by Beavean on 06.04.2024.
//

import Foundation

struct CoinDetails: Decodable {
    let id: String?
    let symbol: String?
    let name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?

    var readableDescription: String? {
        description?.en?.removingHTMLOccurrences
    }
}

struct Description: Decodable {
    let en: String?
}

struct Links: Decodable {
    let homepage: [String]?
    let subredditURL: String?
    private let twitterScreenName: String?
    private let telegramChannelIdentifier: String?

    var twitterURL: String? {
        guard let twitterName = twitterScreenName, !twitterName.isEmpty else { return nil }
        return Constants.twitterBaseUrl + twitterName
    }

    var telegramURL: String? {
        guard let telegramIdentifier = telegramChannelIdentifier, !telegramIdentifier.isEmpty else { return nil }
        return Constants.telegramBaseUrl + telegramIdentifier
    }
}
