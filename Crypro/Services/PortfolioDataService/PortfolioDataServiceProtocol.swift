//
//  PortfolioDataServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine

protocol PortfolioDataServiceProtocol {
    var savedEntitiesPublisher: Published<[Portfolio]>.Publisher { get }
    var savedEntitiesPublished: Published<[Portfolio]> { get }
    func updatePortfolio(coin: Coin, amount: Double)
    func getPortfolio()
}
