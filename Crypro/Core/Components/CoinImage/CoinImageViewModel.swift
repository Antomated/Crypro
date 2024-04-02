//
//  CoinImageViewModel.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {

    @Published var image: UIImage?
    @Published var isLoading: Bool = true

    private let coin: Coin
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        isLoading = true
        addSubscribers()
    }

    private func addSubscribers() {
        dataService.$image
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables)
    }
}
