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
    private var coinSubscription: AnyCancellable?
    let coin: Coin

    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        coinSubscription = NetworkManager.download(from: .coinDetails(id: coin.id), convertTo: CoinDetails.self)
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
