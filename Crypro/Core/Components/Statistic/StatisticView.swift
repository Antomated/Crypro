//
//  StatisticView.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
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
            HStack {
                SystemImage.statisticChangeArrow.image
                    .font(.caption2)
                    .rotationEffect(.init(
                        degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    Group {
        StatisticView(stat: PreviewData.stubStatistic1)
            .padding()
        StatisticView(stat: PreviewData.stubStatistic2)
            .padding()
        StatisticView(stat: PreviewData.stubStatistic3)
            .padding()
    }
}
