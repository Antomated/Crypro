//
//  CoinImageServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Foundation

protocol CoinImageServiceProtocol {
    var imageDataPublisher: Published<Data?>.Publisher { get }
    var imageDataPublished: Published<Data?> { get }
    func getCoinImage()
}
