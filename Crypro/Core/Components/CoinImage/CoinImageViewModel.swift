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
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        dataService = CoinImageService(coin: coin)
        isLoading = true
        addSubscribers()
    }

    private func addSubscribers() {
        dataService.$imageData
            .sink(receiveValue: { [weak self] image in
                guard let self else { return }
                isLoading = false
                coinImageData = image
            })
            .store(in: &cancellables)
    }
}
