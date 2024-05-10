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
    @Published var error: NetworkError?
    private var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    func getCoins() {
        coinSubscription = NetworkManager.download(from: .allCoins, convertTo: [Coin].self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(networkError) = completion {
                        error = networkError
                    }
                },
                receiveValue: { [weak self] coins in
                    guard let self else { return }
                    allCoins = coins
                    coinSubscription?.cancel()
                }
            )
    }
}
