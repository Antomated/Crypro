//
//  CoinLogoView.swift
//  Crypro
//
//  Created by Anton Petrov on 04.04.2024.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin

    var body: some View {
        HStack {
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(coin.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(coin.name)
                    .font(.caption2)
                    .foregroundStyle(Color.theme.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(8)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    CoinLogoView(coin: Coin.coin)
}
