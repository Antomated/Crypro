//
//  CoinDetailsServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine

protocol CoinDetailsServiceProtocol {
    var coinDetailsPublisher: Published<CoinDetails?>.Publisher { get }
    var coinDetailsPublished: Published<CoinDetails?> { get }
    var errorPublisher: Published<NetworkError?>.Publisher { get }
    var errorPublished: Published<NetworkError?> { get }
    func getCoinDetails()
}
