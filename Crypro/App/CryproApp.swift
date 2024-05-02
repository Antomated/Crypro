//
//  CryproApp.swift
//  Crypro
//
//  Created by Anton Petrov on 01.04.2024.
//
// TODO: Update to navigation link?

import SwiftUI

@main
struct CryproApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showLaunchView: Bool = true

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
                .accentColor(ColorTheme().green)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
