//
//  HomeView.swift
//  Crypro
//
//  Created by Antomated on 01.04.2024.
//

import CoreHaptics
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showEditPortfolioView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showEditPortfolioView,
                           content: {
                        if let selectedCoin = viewModel.selectedCoin {
                            EditPortfolioView(singleCoin: selectedCoin,
                                              portfolioDataService: viewModel.portfolioDataService,
                                              coinImageService: viewModel.coinImageService)
                        } else {
                            EditPortfolioView(allCoins: viewModel.allCoins,
                                              portfolioDataService: viewModel.portfolioDataService,
                                              coinImageService: viewModel.coinImageService)
                        }
                    })
                VStack {
                    HeaderView(showPortfolio: $showPortfolio)
                        .padding()
                    homeStatisticsView
                        .frame(height: 130)
                    Divider()
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding(.horizontal)
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
            .overlay {
                if viewModel.showLaunchView {
                    LoaderView()
                        .ignoresSafeArea()
                }
            }
            .navigationDestination(isPresented: $showDetailView) {
                DetailLoadingView(coin: viewModel.selectedCoin,
                                  portfolioDataService: viewModel.portfolioDataService,
                                  coinImageService: viewModel.coinImageService,
                                  coinDetailService: viewModel.coinDetailsService)
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
    var homeStatisticsView: some View {
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
                                showEditView()
                            } else {
                                showSettingsView.toggle()
                            }
                        }
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
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.allCoins, id: \.id) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false, coinImageService: viewModel.coinImageService)
                        .listRowInsets(.init(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)))
                        .padding(12)
                        .onTapGesture {
                            HapticManager.triggerSelection()
                            segue(coin: coin)
                        }
                        .listRowBackground(Color.theme.background)
                        .swipeActions {
                            Button {
                                selectCoinAndShowEditView(coin: coin)
                            } label: {
                                SystemImage.filledPlus.image
                                    .tint(Color.theme.background)
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
            .listStyle(.plain)
            .mask(LinearGradient(gradient: Gradient(colors: [.theme.black,
                                                             .theme.black,
                                                             .theme.black,
                                                             .clear]),
                                 startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .onReceive(viewModel.$allCoins) { _ in
                withAnimation {
                    if let firstCoin = viewModel.allCoins.first {
                        proxy.scrollTo(firstCoin.id, anchor: .top)
                    }
                }
            }
        }
    }

    var allPortfolioCoinsList: some View {
        ScrollViewReader { proxy in

            List {
                ForEach(viewModel.portfolioCoins, id: \.id) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: true, coinImageService: viewModel.coinImageService)
                        .listRowInsets(.init(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)))
                        .padding(12)
                        .onTapGesture {
                            segue(coin: coin)
                        }
                        .listRowBackground(Color.theme.background)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteCoin(coin)
                            } label: {
                                SystemImage.thrash.image
                                    .tint(Color.theme.background)
                            }
                            Button {
                                selectCoinAndShowEditView(coin: coin)
                            } label: {
                                SystemImage.filledPlus.image
                                    .tint(Color.theme.background)
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
            .listStyle(.plain)
            .mask(LinearGradient(gradient: Gradient(colors: [.theme.black,
                                                             .theme.black,
                                                             .theme.black,
                                                             .clear]),
                                 startPoint: .top, endPoint: .bottom))
            .onReceive(viewModel.$portfolioCoins) { _ in
                withAnimation {
                    if let firstCoin = viewModel.portfolioCoins.first {
                        proxy.scrollTo(firstCoin.id, anchor: .top)
                    }
                }
            }
        }
    }

    var columnTitles: some View {
        HStack {
            HStack {
                Text("#")
                Text(LocalizationKey.coinRow.localizedString)
                    .padding(.leading, 8)
                SystemImage.chevronDown.image
                    .rotationEffect(.radians(viewModel.sortOption == .rank ? 0 : .pi))
            }
            .foregroundStyle(viewModel.sortOption == .rank || viewModel.sortOption == .rankDescending
                             ? Color.theme.green
                             : Color.theme.secondaryText)
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
                        .rotationEffect(.radians(viewModel.sortOption == .holdings ? 0 : .pi))
                }
                .foregroundStyle(viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsDescending
                                 ? Color.theme.green
                                 : Color.theme.secondaryText)
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsDescending : .holdings
                    }
                }

            } else {
                HStack {
                    Text(LocalizationKey.totalVolumeRow.localizedString)
                    SystemImage.chevronDown.image
                        .rotationEffect(.radians(viewModel.sortOption == .totalVolume ? 0 : .pi))
                }
                .foregroundStyle(viewModel.sortOption == .totalVolume
                                 || viewModel.sortOption == .totalVolumeDescending
                                 ? Color.theme.green
                                 : Color.theme.secondaryText)
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
                    .rotationEffect(.radians(viewModel.sortOption == .price ? 0 : .pi))
            }
            .foregroundStyle(viewModel.sortOption == .price || viewModel.sortOption == .priceDescending
                             ? Color.theme.green
                             : Color.theme.secondaryText)
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
        .font(.chakraPetch(.medium, size: 14))
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.top, 8)
        .padding(.horizontal, 22)
    }

    var portfolioEmptyText: some View {
        Text(LocalizationKey.portfolioTip.localizedString)
            .font(.chakraPetch(.medium, size: 12))
            .foregroundStyle(Color.theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}

// MARK: - Private methods

private extension HomeView {
    func segue(coin: Coin) {
        viewModel.selectedCoin = coin
        showDetailView.toggle()
    }

    private func showEditView() {
        selectCoinAndShowEditView(coin: nil)
    }

    private func selectCoinAndShowEditView(coin: Coin?) {
        viewModel.selectedCoin = coin
        showEditPortfolioView = true
    }
}

#Preview {
    NavigationView {
        HomeView(viewModel: HomeViewModel(coinImageService: CoinImageService(networkManager: NetworkManager(),
                                                                             imageDataProvider: ImageDataProvider()),
                                          coinDataService: CoinDataService(networkManager: NetworkManager()),
                                          marketDataService: MarketDataService(networkManager: NetworkManager()),
                                          coinDetailsService: CoinDetailsService(networkManager: NetworkManager()),
                                          portfolioDataService: PortfolioDataService()))
        .navigationBarHidden(true)
    }
}
