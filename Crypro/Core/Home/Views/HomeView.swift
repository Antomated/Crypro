//
//  HomeView.swift
//  Crypro
//
//  Created by Beavean on 01.04.2024.
//

import CoreHaptics
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
                            allCoinsList
                                .transition(.move(edge: .leading))
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
                    SettingsView(isPresented: $showSettingsView)
                })
            }
            .navigationDestination(isPresented: $showDetailView) {
                DetailLoadingView(coin: $selectedCoin)
            }
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text(LocalizationKey.errorTitle.localizedString),
                    message: Text(error.message),
                    dismissButton: .default(Text(LocalizationKey.okButton.localizedString),
                                            action: {
                                                viewModel.error = nil
                                            })
                )
            }
        }
    }
}

// MARK: - UI Components

private extension HomeView {
    var homeFooter: some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    CircleButtonView(icon: showPortfolio ? .plus : .info)
                        .animation(.none, value: showPortfolio)
                        .onTapGesture {
                            HapticManager.triggerSelection()
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
                    .rotationEffect(.radians(showPortfolio ? .pi : 0))
                    .onTapGesture {
                        HapticManager.triggerSelection()
                        withAnimation(.spring()) {
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding(24)
        }
        .ignoresSafeArea()
    }

    var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10)))
                    .padding(.vertical, 4)
                    .onTapGesture {
                        HapticManager.triggerSelection()
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
                    .padding(.horizontal, 12)
                    .swipeActions {
                        Button {
                            withAnimation {
                                showPortfolio.toggle()
                                showPortfolioView.toggle()
                                viewModel.selectedCoin = coin
                            }
                        } label: {
                            SystemImage.filledPlus.image
                        }
                        .tint(Color.theme.green)
                    }
            }
        }
        .overlay {
            if viewModel.showLaunchView {
                LoaderView()
                    .ignoresSafeArea()
            }
        }
        .refreshable {
            viewModel.reloadData()
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
        .ignoresSafeArea()
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
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteCoin(coin)
                        } label: {
                            SystemImage.thrash.image
                        }
                        Button {
                            showPortfolioView.toggle()
                            viewModel.selectedCoin = coin
                        } label: {
                            SystemImage.filledPlus.image
                        }
                        .tint(Color.theme.green)
                    }
            }
        }
        .refreshable {
            viewModel.reloadData()
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
                    .foregroundStyle(viewModel.sortOption == .rank || viewModel.sortOption == .rankDescending
                        ? Color.theme.green
                        : Color.theme.secondaryText)
                    .rotationEffect(.radians(viewModel.sortOption == .rank ? 0 : .pi))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankDescending : .rank
                }
            }

            Spacer()

            if showPortfolio {
                HStack {
                    Text(LocalizationKey.holdingsRow.localizedString)
                    SystemImage.chevronDown.image
                        .foregroundStyle(viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsDescending
                            ? Color.theme.green
                            : Color.theme.secondaryText)
                        .rotationEffect(.radians(viewModel.sortOption == .holdings ? 0 : .pi))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsDescending : .holdings
                    }
                }
            } else {
                HStack {
                    Text(LocalizationKey.totalVolumeRow.localizedString)
                    SystemImage.chevronDown.image
                        .foregroundStyle(viewModel.sortOption == .totalVolume
                                         || viewModel.sortOption == .totalVolumeDescending
                                         ? Color.theme.green
                                         : Color.theme.secondaryText)
                        .rotationEffect(.radians(viewModel.sortOption == .totalVolume ? 0 : .pi))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .totalVolume
                        ? .totalVolumeDescending
                        : .totalVolume
                    }
                }
            }

            HStack {
                Text(LocalizationKey.priceRow.localizedString)
                    .frame(width: UIScreen.main.bounds.width / 6.2, alignment: .trailing)
                SystemImage.chevronDown.image
                    .foregroundStyle(viewModel.sortOption == .price || viewModel.sortOption == .priceDescending
                        ? Color.theme.green
                        : Color.theme.secondaryText)
                    .rotationEffect(.radians(viewModel.sortOption == .price ? 0 : .pi))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceDescending : .price
                }
            }

            Button {
                    viewModel.reloadData()
            } label: {
                SystemImage.goForward.image
            }
            .rotationEffect(.radians(viewModel.isLoading ? 2 * .pi : 0), anchor: .center)
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

// MARK: - Private methods

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
    .environmentObject(HomeViewModel())
}
