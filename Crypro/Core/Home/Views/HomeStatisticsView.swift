//
//  HomeStatisticsView.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import SwiftUI

struct HomeStatisticsView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(viewModel.statistics) { statPair in
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

#Preview {
    HomeStatisticsView(showPortfolio: .constant(false))
        .environmentObject(HomeViewModel())
}
