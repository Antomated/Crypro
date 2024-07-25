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
    private let networkManager: NetworkServiceProtocol
    private var coinSubscription: AnyCancellable?

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
        getCoins()
    }
}

// MARK: - CoinDataServiceProtocol

extension CoinDataService: CoinDataServiceProtocol {
    var allCoinsPublisher: Published<[Coin]>.Publisher { $allCoins }
    var errorPublisher: Published<NetworkError?>.Publisher { $error }

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
