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

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        coinSubscription = NetworkManager.download(from: .coinDetails(id: coin.id))
            .decode(type: CoinDetails.self, decoder: decoder)
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
