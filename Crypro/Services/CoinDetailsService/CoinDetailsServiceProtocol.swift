//
//  CoinDetailsServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine

protocol CoinDetailsServiceProtocol {
    var coinDetailsPublisher: Published<CoinDetails?>.Publisher { get }
    var errorPublisher: Published<NetworkError?>.Publisher { get }
    func getCoinDetails()
}
