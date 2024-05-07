//
//  CoinImageView.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel

    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = viewModel.coinImage {
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
    CoinImageView(coin: PreviewData.stubCoin)
}
