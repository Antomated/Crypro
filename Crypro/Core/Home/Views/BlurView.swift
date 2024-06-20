//
//  BlurView.swift
//  Crypro
//
//  Created by Beavean on 08.05.2024.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context _: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    ZStack {
        LoaderView()
        BlurView(style: .regular)
    }
}
