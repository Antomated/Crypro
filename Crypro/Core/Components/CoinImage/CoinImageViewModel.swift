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
    private var cancellables = Set<AnyCancellable>()
    private let coinImageService: CoinImageServiceProtocol
    private let coinID: String

    init(coin: Coin, coinImageService: CoinImageServiceProtocol) {
        coinID = coin.id
        self.coinImageService = coinImageService
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
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] imageData in
                self?.isLoading = false
                self?.coinImageData = imageData
            })
            .store(in: &cancellables)
    }
}
