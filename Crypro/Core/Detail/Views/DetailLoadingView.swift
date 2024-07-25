//
//  DetailLoadingView.swift
//  Crypro
//
//  Created by Antomated on 07.06.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    var coin: Coin?
    let portfolioDataService: PortfolioDataServiceProtocol
    let coinImageService: CoinImageServiceProtocol
    let coinDetailService: CoinDetailsServiceProtocol

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin,
                           portfolioDataService: portfolioDataService,
                           coinDetailService: coinDetailService,
                           coinImageService: coinImageService)
            }
        }
    }
}
