//
//  CoinDetailsService.swift
//  Crypro
//
//  Created by Antomated on 06.04.2024.
//

import Combine
import Foundation

final class CoinDetailsService {
    @Published var coinDetails: CoinDetails?
    @Published var error: NetworkError?
    private let networkManager: NetworkServiceProtocol
    private var coinSubscription: AnyCancellable?
    private let coin: Coin

    init(coin: Coin, networkManager: NetworkServiceProtocol) {
        self.coin = coin
        self.networkManager = networkManager
        getCoinDetails()
    }
}

// MARK: - CoinDetailsServiceProtocol

extension CoinDetailsService: CoinDetailsServiceProtocol {
    var coinDetailsPublisher: Published<CoinDetails?>.Publisher { $coinDetails }
    var errorPublisher: Published<NetworkError?>.Publisher { $error }

    func getCoinDetails() {
        coinSubscription = networkManager.download(from: .coinDetails(id: coin.id), convertTo: CoinDetails.self)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(networkError) = completion {
                        error = networkError
                    }
                },
                receiveValue: { [weak self] details in
                    guard let self else { return }
                    coinDetails = details
                }
            )
    }
}
