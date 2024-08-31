//
//  CoinInfoSource.swift
//  Crypro
//
//  Created by Antomated on 05.06.2024.
//

import Foundation

struct CoinInfoSource: Decodable {
    let homepage: [String]?
    let subredditURL: String?
    private let twitterScreenName: String?
    private let telegramChannelIdentifier: String?

    var twitterURL: String? {
        guard let twitterName = twitterScreenName, !twitterName.isEmpty else { return nil }
        return Constants.xcomBaseURL + twitterName
    }

    var telegramURL: String? {
        guard let telegramIdentifier = telegramChannelIdentifier, !telegramIdentifier.isEmpty else { return nil }
        return Constants.telegramBaseURL + telegramIdentifier
    }
}
