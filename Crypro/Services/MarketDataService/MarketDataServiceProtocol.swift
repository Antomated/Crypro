//
//  MarketDataServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine

protocol MarketDataServiceProtocol {
    var marketDataPublisher: Published<MarketData?>.Publisher { get }
    var marketDataPublished: Published<MarketData?> { get }
    var errorPublisher: Published<NetworkError?>.Publisher { get }
    var errorPublished: Published<NetworkError?> { get }
    func getData()
}
