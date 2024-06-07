//
//  HomeStatisticsView.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import SwiftUI

struct HomeStatisticsView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    private let horizontalPadding: CGFloat = 12
    private let numberOfColumns: CGFloat = 3

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(viewModel.statistics) { stat in
                    StatisticView(stat: stat)
                        .frame(width: (geometry.size.width - horizontalPadding) / numberOfColumns)
                        .offset(x: showPortfolio ? 0 : -horizontalPadding)
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
