//
//  CoinImageViewModel.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import Combine
import Foundation

final class CoinImageViewModel: ObservableObject {
    @Published var coinImageData: Data?
    @Published var isLoading: Bool = true
    private let coinImageService: CoinImageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let coinID: String

    init(coin: Coin, networkManager: NetworkServiceProtocol) {
        self.coinID = coin.id
        // TODO: move to root composition
        coinImageService = CoinImageService(networkManager: networkManager)
        isLoading = true
        addSubscribers()
        coinImageService.getCoinImage(for: coin)
    }

    private func addSubscribers() {
        coinImageService.imageDataPublisher
            .map { [weak self] imageDataDict -> Data? in
                guard let self = self else { return nil }
                return imageDataDict[self.coinID]
            }
            .sink(receiveValue: { [weak self] imageData in
                guard let self = self else { return }
                self.isLoading = false
                self.coinImageData = imageData
            })
            .store(in: &cancellables)
    }
}
