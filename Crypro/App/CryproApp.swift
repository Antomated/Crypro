//
//  CryproApp.swift
//  Crypro
//
//  Created by Antomated on 01.04.2024.
//

import SwiftUI

@main
struct CryproApp: App {
    @AppStorage(Constants.selectedTheme) private var darkThemeIsOn: Bool = defaultDarkMode
    @StateObject private var homeViewModel: HomeViewModel
    @State private var showLaunchView = true

    private static var defaultDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }

    init() {
        let networkManager = NetworkServiceManager()
        let coinDataService = CoinDataService(networkManager: networkManager)
        let marketDataService = MarketDataService(networkManager: networkManager)
        let portfolioDataService = PortfolioDataService()
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(
            networkManager: networkManager,
            coinDataService: coinDataService,
            marketDataService: marketDataService,
            portfolioDataService: portfolioDataService
        ))
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView(viewModel: homeViewModel)
                }
                .navigationViewStyle(.stack)
                .environmentObject(homeViewModel)
                .accentColor(.theme.green)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView, loadingData: $homeViewModel.showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            .preferredColorScheme(darkThemeIsOn == true ? .dark : .light)
        }
    }
}
