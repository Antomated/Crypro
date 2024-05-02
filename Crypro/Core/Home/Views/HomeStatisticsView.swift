//
//  HomeStatisticsView.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import SwiftUI

struct HomeStatisticsView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
                // TODO: Geometry reader on UIScreen.main.bounds.width
                    .frame(width: (UIScreen.main.bounds.width - 12) / 3)
                    .offset(x: showPortfolio ? 0 : -12)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatisticsView(showPortfolio: .constant(false))
        .environmentObject(HomeViewModel())
}
