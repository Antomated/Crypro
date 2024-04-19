//
//  CoinDetail.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//
// TODO: Add real links to socials

import Foundation

struct CoinDetails: Decodable {
    let id: String?
    let symbol: String?
    let name: String?
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

struct Description: Decodable {
    let en: String?
}

struct Links: Decodable {
    let homepage: [String]?
    let twitterScreenName: String?
    let facebookUsername: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
}
