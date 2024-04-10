//
//  CoinDetail.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//

import Foundation

// MARK: - CoinDetail
struct CoinDetails: Decodable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let previewListing: Bool?
    let description: Description?
    let links: Links?

    var readableDescription: String? {
        description?.en?.removingHTMLOccurrences
    }
}

// MARK: - Description
struct Description: Decodable {
    let en: String?
}

// MARK: - Links
struct Links: Decodable {
    let homepage: [String]?
    let twitterScreenName, facebookUsername: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
}
