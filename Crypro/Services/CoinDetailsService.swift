//
//  CoinDetailService.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//

import Foundation
import Combine

final class CoinDetailsService {

    @Published var coinDetails: CoinDetails?
    var coinSubscription: AnyCancellable?
    let coin: Coin

    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        coinSubscription = NetworkManager.download(from: .coinDetails(id: coin.id), convertTo: CoinDetails.self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] coinDetails in
                    self?.coinDetails = coinDetails
                    self?.coinSubscription?.cancel()
                }
            )
    }
}
