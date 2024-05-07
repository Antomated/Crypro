//
//  CoinDataService.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Combine
import Foundation

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
                    guard let self else { return }
                    allCoins = coins
                    coinSubscription?.cancel()
                }
            )
    }
}
