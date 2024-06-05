//
//  CoinDetail.swift
//  Crypro
//
//  Created by Beavean on 06.04.2024.
//

import Foundation

struct CoinDetails: Decodable {
    struct Description: Decodable {
        let en: String?
    }

    let id: String?
    let symbol: String?
    let name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: CoinInfoSource?

    var readableDescription: String? {
        description?.en?.removingHTMLOccurrences
    }
}
