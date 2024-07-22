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
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showLaunchView = true

    private static var defaultDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
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
