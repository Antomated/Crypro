//
//  HomeViewModel.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var selectedCoin: Coin?
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .rank

    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) { [weak self] in
            guard let self else { return }
            self.allCoins.append(Development.coin)
            self.portfolioCoins.append(Development.coin)
        }
    }
}
