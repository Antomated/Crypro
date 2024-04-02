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

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
