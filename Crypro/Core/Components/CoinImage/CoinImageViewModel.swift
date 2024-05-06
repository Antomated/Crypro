//
//  CoinImageViewModel.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import Combine
import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
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
                self?.isLoading = false
                self?.image = image
            })
            .store(in: &cancellables)
    }
}
