//
//  CoinRowView.swift
//  Crypro
//
//  Created by Antomated on 02.04.2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool
    private let rightColumnWidthToScreenRatio: CGFloat = 3.5
    private(set) var networkManager: NetworkManaging

    var marketCapDisplay: String {
        if let totalVolume = coin.totalVolume {
            return "$ " + totalVolume.formattedWithAbbreviations()
        } else {
            return LocalizationKey.notAvailable.localizedString
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            centralColumn
            rightColumn
        }
        .contentShape(.rect)
    }
}

// MARK: - UI Components

private extension CoinRowView {
    var leftColumn: some View {
        HStack(spacing: 2) {
            Text("\(coin.rank)")
                .font(.chakraPetch(.regular, size: 12))
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin, networkManager: networkManager)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 0) {
                Text(coin.symbol.uppercased())
                    .font(.chakraPetch(.bold, size: 16))
                    .tracking(1)
                    .foregroundColor(Color.theme.accent)
                GeometryReader { geometry in
                    Text(coin.name)
                        .font(.chakraPetch(.regular, size: 13))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(width: geometry.size.width, alignment: .leading)
                        .lineLimit(1)
                }
            }
            .padding(.leading, 6)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }

    var centralColumn: some View {
        VStack(alignment: .trailing) {
            if showHoldingsColumn {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .font(.chakraPetch(.bold, size: 13))
                Text(coin.formattedCurrentHoldings)
                    .font(.chakraPetch(.regular, size: 12))
            } else {
                Text(marketCapDisplay)
                    .font(.chakraPetch(.medium, size: 13))
            }
        }
        .tracking(1)
        .foregroundStyle(Color.theme.accent)
    }

    var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text((coin.currentPrice ?? 0.0).asCurrencyWith6Decimals())
                .foregroundStyle(Color.theme.accent)
                .font(.chakraPetch(.bold, size: 13))
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.theme.green : Color.theme.red
                )
                .font(.chakraPetch(.medium, size: 12))
        }
        .tracking(1)
        .frame(width: UIScreen.main.bounds.width / rightColumnWidthToScreenRatio,
               alignment: .trailing)
    }
}

#Preview {
    CoinRowView(coin: CoinsStubs.bitcoin, showHoldingsColumn: true, networkManager: NetworkManager())
}
