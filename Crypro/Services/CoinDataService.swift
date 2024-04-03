//
//  CoinDataService.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//
// TODO: Naming

import Foundation
import Combine

final class CoinDataService {

    @Published var allCoins: [Coin] = []
    private var coinSubscription: AnyCancellable?

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init() {
        getCoins()
    }

    func getCoins() {
        coinSubscription = NetworkManager.download(from: .allCoins)
            .decode(type: [Coin].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] coins in
                    self?.allCoins = coins
                    self?.coinSubscription?.cancel()
                }
            )
    }
}
