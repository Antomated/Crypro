//
//  CryproApp.swift
//  Crypro
//
//  Created by Beavean on 01.04.2024.
//

import SwiftUI

@main
struct CryproApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showLaunchView = true

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
        }
    }
}
