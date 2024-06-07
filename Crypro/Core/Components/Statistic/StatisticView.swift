//
//  StatisticView.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            if let statPercentageChange = stat.percentageChange {
                HStack {
                    SystemImage.statisticChangeArrow.image
                        .font(.caption2)
                        .rotationEffect(.init(
                            degrees: statPercentageChange >= 0 ? 0 : 180)
                        )
                    Text(statPercentageChange.asPercentString())
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(statPercentageChange >= 0 ? Color.theme.green : Color.theme.red)
            } else {
                HStack {
                    SystemImage.minus.image
                        .font(.caption2)
                        .rotationEffect(.init(
                            degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180)
                        )
                    Text(LocalizationKey.zeroStatChange.localizedString)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    Group {
        StatisticView(stat: CoinsStubs.marketCap)
            .padding()
        StatisticView(stat: CoinsStubs.totalVolume)
            .padding()
        StatisticView(stat: CoinsStubs.portfolio)
            .padding()
    }
}
