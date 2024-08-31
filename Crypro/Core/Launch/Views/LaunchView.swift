//
//  LaunchView.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText: [String] = Constants.appName.map { String($0) }
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var showSlowLoadingMessage: Bool = false
    @State private var visibleChars: Int = 0
    @Binding var showLaunchView: Bool
    @Binding var loadingData: Bool

    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    private let disappearanceTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    private let slowLoadingTimer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

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
                                .font(.chakraPetch(.bold, size: 20))
                                .foregroundStyle(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)

            if showSlowLoadingMessage {
                HStack(spacing: 2) {
                    ForEach(0..<LocalizationKey.longLoadingMessage.localizedString.count, id: \.self) { index in
                        let char = Array(LocalizationKey.longLoadingMessage.localizedString)[index]
                        Text(String(char))
                            .font(.chakraPetch(.medium, size: 14))
                            .foregroundColor(ColorTheme().secondaryText)
                            .opacity(visibleChars <= index && char != " " ? 0 : 1)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding(.top, 100)
                .offset(y: UIScreen.main.bounds.height / 3)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            updateCounterAndLoops()
        }
        .onReceive(disappearanceTimer) { _ in
            updateVisibleChars()
        }
        .onReceive(slowLoadingTimer) { _ in
            showSlowLoadingMessage = true
        }
    }

    private func updateCounterAndLoops() {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                if counter == loadingText.count - 1 {
                    loops += 1
                    counter = 0
                    if loops >= 2 && !loadingData {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }

    private func updateVisibleChars() {
        if showSlowLoadingMessage {
            if visibleChars > 0 {
                visibleChars -= 1
            } else {
                visibleChars = LocalizationKey.longLoadingMessage.localizedString.count
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true), loadingData: .constant(true))
}
