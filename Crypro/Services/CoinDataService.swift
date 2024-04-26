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

    init() {
        getCoins()
    }

    func getCoins() {
        coinSubscription = NetworkManager.download(from: .allCoins, convertTo: [Coin].self)
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
