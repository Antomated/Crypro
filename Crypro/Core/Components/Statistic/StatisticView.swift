//
//  StatisticView.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.chakraPetch(.medium, size: 14))
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.chakraPetch(.bold, size: 16))
                .tracking(1)
                .foregroundStyle(Color.theme.accent)
            if let statPercentageChange = stat.percentageChange {
                HStack {
                    SystemImage.statisticChangeArrow.image
                        .font(.caption2)
                        .rotationEffect(.radians(statPercentageChange >= 0 ? 0 : .pi))
                    Text(statPercentageChange.asPercentString())
                        .font(.chakraPetch(.regular, size: 12))
                        .bold()
                }
                .foregroundStyle(statPercentageChange >= 0 ? Color.theme.green : Color.theme.red)
            } else {
                Text(LocalizationKey.zeroStatChange.localizedString)
                    .multilineTextAlignment(.center)
                    .font(.chakraPetch(.regular, size: 12))
                    .bold()
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
