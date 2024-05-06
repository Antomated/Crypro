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
    @State private var showPortfolioView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: Coin?

    var body: some View {
        NavigationStack {
            ZStack {
                // background
                Color.theme.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showPortfolioView, content: {
                        PortfolioView()
                    })

                // content layer
                VStack {
                    Text(showPortfolio
                         ? LocalizationKey.portfolio.localizedString
                         : LocalizationKey.livePrices.localizedString)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Color.theme.accent)
                    .animation(.none, value: showPortfolio)
                    .padding(.top)
                    HomeStatisticsView(showPortfolio: $showPortfolio)
                        .padding(.top)
                        .frame(height: 70)
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    columnTitles
                    ZStack {
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
                        homeFooter
                            .zIndex(1)
                            .shadow(color: .theme.background, radius: 20)
                    }
                }
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                })
            }
            .navigationDestination(isPresented: $showDetailView) {
                DetailLoadingView(coin: $selectedCoin)
            }
        }
    }
}

// MARK: COMPONENTS

private extension HomeView {
    var homeFooter: some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    CircleButtonView(icon: showPortfolio ? .plus : .info)
                        .animation(.none, value: showPortfolio)
                        .onTapGesture {
                            if showPortfolio {
                                showPortfolioView.toggle()
                            } else {
                                showSettingsView.toggle()
                            }
                        }
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
                .frame(maxWidth: 60, maxHeight: 60)
                Spacer()
                CircleButtonView(icon: .chevronRight)
                    .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding([.leading, .trailing], 24)
        }
    }

    var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)))
                    .padding(.vertical, 4)
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
                    .padding(.horizontal, 12)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Spacer()
                .frame(height: 100)
        }
        .listStyle(.plain)
        .mask(LinearGradient(gradient: Gradient(colors: [.theme.black,
                                                         .theme.black,
                                                         .theme.black,
                                                         .clear]),
                             startPoint: .top, endPoint: .bottom))
    }

    var allPortfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)))
                    .padding(.vertical, 4)
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Spacer()
                .frame(height: 100)
        }
        .padding(.horizontal, 12)
        .listStyle(.plain)
        .mask(LinearGradient(gradient: Gradient(colors: [.theme.black,
                                                         .theme.black,
                                                         .theme.black,
                                                         .clear]),
                             startPoint: .top, endPoint: .bottom))
    }

    var columnTitles: some View {
        HStack {

            HStack {
                Text("#")
                Text(LocalizationKey.coinRow.localizedString)
                    .padding(.leading, 4)
                SystemImage.chevronDown.image
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
                    Text(LocalizationKey.holdingsRow.localizedString)
                    SystemImage.chevronDown.image
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
                Text(LocalizationKey.priceRow.localizedString)
                    .frame(width: UIScreen.main.bounds.width / 6.2, alignment: .trailing)
                SystemImage.chevronDown.image
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
                    viewModel.reloadData()
                }
            } label: {
                SystemImage.goForward.image
            }
            .rotationEffect(.init(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.top, 8)
        .padding(.horizontal, 22)
    }

    var portfolioEmptyText: some View {
        Text(LocalizationKey.portfolioTip.localizedString)
            .font(.callout.weight(.medium))
            .foregroundStyle(Color.theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}

// MARK: - PRIVATE METHODS

private extension HomeView {
    func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(PreviewData.homeViewModel)
}
