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

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init() { 
        getData()
    }

    func getData() {
        marketDataSubscription = NetworkManager.download(from: .globalData)
            .decode(type: GlobalData.self, decoder: decoder)
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
