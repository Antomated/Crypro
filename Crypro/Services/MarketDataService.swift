//
//  MarketDataService.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import Foundation
import Combine

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
                    self?.marketData = globalData.data
                    self?.marketDataSubscription?.cancel()
                }
            )
    }
}
