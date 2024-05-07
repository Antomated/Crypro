//
//  MarketDataService.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import Combine
import Foundation

final class MarketDataService {
    @Published var marketData: MarketData?
    private var marketDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        marketDataSubscription = NetworkManager.download(from: .globalData, convertTo: GlobalData.self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] globalData in
                    guard let self else { return }
                    marketData = globalData.data
                    marketDataSubscription?.cancel()
                }
            )
    }
}
