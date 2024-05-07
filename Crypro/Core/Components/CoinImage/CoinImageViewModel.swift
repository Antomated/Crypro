//
//  CoinImageViewModel.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import Combine
import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Published var coinImage: UIImage?
    @Published var isLoading: Bool = true

    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        dataService = CoinImageService(coin: coin)
        isLoading = true
        addSubscribers()
    }

    private func addSubscribers() {
        dataService.$image
            .sink(receiveValue: { [weak self] image in
                guard let self else { return }
                isLoading = false
                coinImage = image
            })
            .store(in: &cancellables)
    }
}
