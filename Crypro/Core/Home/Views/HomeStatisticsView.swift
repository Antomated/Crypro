//
//  HomeStatisticsView.swift
//  Crypro
//
//  Created by Antomated on 31.08.2024.
//

import SwiftUI

struct HomeStatisticsView: View {
    @Binding var showPortfolio: Bool
    var statistics: [StatisticPair]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(statistics) { statPair in
                    VStack(alignment: .leading, spacing: 12) {
                        StatisticView(stat: statPair.top)
                        Divider()
                            .frame(width: 70)
                        StatisticView(stat: statPair.bottom)
                    }
                    .frame(width: (geometry.size.width - 12) / 3)
                    .offset(x: showPortfolio ? 0 : -12)
                }
            }
            .frame(
                width: geometry.size.width,
                alignment: showPortfolio ? .trailing : .leading
            )
        }
    }
}
