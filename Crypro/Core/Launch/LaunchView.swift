//
//  LaunchView.swift
//  Crypro
//
//  Created by Beavean on 04.04.2024.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText: [String] = Constants.appName.map { String($0) }
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool

    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()

            Image(.logo)
                .resizable()
                .frame(width: 100, height: 100)

            ZStack {
                if showLoadingText {
                    HStack(spacing: 4) {
                        ForEach(loadingText.indices, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline.weight(.heavy))
                                .foregroundStyle(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .ignoresSafeArea()
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                if counter == loadingText.count - 1 {
                    loops += 1
                    counter = 0
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
