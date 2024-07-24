//
//  CoinDataService.swift
//  Crypro
//
//  Created by Antomated on 02.04.2024.
//

import Combine
import Foundation

final class CoinDataService {
    @Published var allCoins: [Coin] = []
    @Published var error: NetworkError?
    private let networkManager: NetworkManaging
    private var coinSubscription: AnyCancellable?

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
        getCoins()
    }

    func getCoins() {
        coinSubscription = networkManager.download(from: .allCoins, convertTo: [Coin].self)
            .first()
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
                }
            )
    }
}
