//
//  CoinDataServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine

protocol CoinDataServiceProtocol {
    var allCoinsPublisher: Published<[Coin]>.Publisher { get }
    var allCoinsPublished: Published<[Coin]> { get }
    var errorPublisher: Published<NetworkError?>.Publisher { get }
    var errorPublished: Published<NetworkError?> { get }
    func getCoins()
}
