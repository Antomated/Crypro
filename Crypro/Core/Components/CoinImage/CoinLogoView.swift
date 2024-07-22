//
//  CoinLogoView.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin

    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)

            Text(coin.symbol.uppercased())
                .font(.chakraPetch(.bold, size: 18))
                .foregroundColor(.theme.accent)
                .tracking(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .lineLimit(1)

            Text(coin.name)
                .font(.chakraPetch(.medium, size: 12))
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinLogoView(coin: CoinsStubs.bitcoin)
}
