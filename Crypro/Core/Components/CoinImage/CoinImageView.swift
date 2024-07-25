//
//  CoinImageView.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel

    init(coin: Coin, coinImageService: CoinImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin,
                                                                  coinImageService: coinImageService))
    }

    var body: some View {
        ZStack {
            if let imageData = viewModel.coinImageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                SystemImage.questionMark.image
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: CoinsStubs.bitcoin,
                  coinImageService: CoinImageService(networkManager: NetworkManager(),
                                                     imageDataProvider: ImageDataProvider()))
}
