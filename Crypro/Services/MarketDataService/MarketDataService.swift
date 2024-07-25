//
//  MarketDataService.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import Combine
import Foundation

final class MarketDataService {
    @Published var marketData: MarketData?
    @Published var error: NetworkError?
    private let networkManager: NetworkServiceProtocol
    private var marketDataSubscription: AnyCancellable?

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
        getData()
    }
}

// MARK: - MarketDataServiceProtocol

extension MarketDataService: MarketDataServiceProtocol {
    var marketDataPublisher: Published<MarketData?>.Publisher { $marketData }
    var errorPublisher: Published<NetworkError?>.Publisher { $error }

    func getData() {
        marketDataSubscription = networkManager.download(from: .globalData, convertTo: GlobalCryptoMarketData.self)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(networkError) = completion {
                        error = networkError
                    }
                },
                receiveValue: { [weak self] globalData in
                    guard let self else { return }
                    marketData = globalData.data
                }
            )
    }
}
