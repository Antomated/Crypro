//
//  CoinRowView.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool

    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn { centralColumn }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background)
    }
}

// MARK: - COMPONENTS

private extension CoinRowView {
    var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            // TODO: CoinImageView
            VStack(alignment: .leading) {
                Text(coin.symbol.uppercased())
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                Text(coin.name)
                    .font(.caption)
                    .foregroundStyle(Color.theme.secondaryText)
            }
            .padding(.leading, 6)
        }
    }

    var centralColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text(
                (coin.currentHoldings ?? 0) > 1000000
                ? (coin.currentHoldings ?? 0).formattedWithAbbreviations()
                : (coin.currentHoldings ?? 0).asNumberString()
            )
        }
        .font(.footnote)
        .foregroundStyle(Color.theme.accent)
    }

    var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text((coin.currentPrice ?? 0.0).asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green : Color.theme.red
                )
        }
        .font(.footnote)
        // TODO: Geometry reader for iPad?
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

#Preview {
    CoinRowView(coin: Coin.coin, showHoldingsColumn: true)
}
