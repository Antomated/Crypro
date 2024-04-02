//
//  HomeView.swift
//  Crypro
//
//  Created by Anton Petrov on 01.04.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                homeHeader
                columnTitles
                if !showPortfolio {
                    allCoinsList.transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            allPortfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

private extension HomeView {
     var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    var columnTitles: some View {
        HStack {
            HStack {
                Text("#")
                Text("Coin")
                    .padding(.leading, 4)
                Image(systemName: "chevron.down")
                    .foregroundStyle(viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed
                                     ? Color.theme.green
                                     : Color.theme.secondaryText)
                    .rotationEffect(.init(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .foregroundStyle(viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed
                                         ? Color.theme.green
                                         : Color.theme.secondaryText)
                        .rotationEffect(.init(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }

            HStack {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 6.2, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .foregroundStyle(viewModel.sortOption == .price || viewModel.sortOption == .priceReversed
                                     ? Color.theme.green
                                     : Color.theme.secondaryText)
                    .rotationEffect(.init(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 0.2)) {
                    // TODO: Reload
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(.init(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.top, 8)
        .padding(.horizontal, 22)
    }

    var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)))
                    .padding(.vertical, 4)
                    .onTapGesture {
                        // TODO: Segue
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .padding(.horizontal, 12)
        .listStyle(.plain)
    }

    var allPortfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)))
                    .padding(.vertical, 4)
                    .onTapGesture {
                        // TODO: Segue
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .padding(.horizontal, 12)
        .listStyle(.plain)
    }

    var portfolioEmptyText: some View {
        Text("You haven't added any coins to your portfolio yet. Click the + button in the top of the right left corner to get started! 🧐")
            .font(.callout.weight(.medium))
            .foregroundStyle(Color.theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(Development.homeViewModel)
}
