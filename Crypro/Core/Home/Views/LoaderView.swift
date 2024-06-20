//
//  LoaderView.swift
//  Crypro
//
//  Created by Beavean on 08.05.2024.
//

import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.5)
                .animation(
                    .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
                .frame(width: 100, height: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurView(style: .regular))
    }
}

#Preview {
    LoaderView()
}
