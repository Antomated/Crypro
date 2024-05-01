//
//  CircleButtonAnimationView.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 1.0)
            .scale(animate ? 1 : 0.5)
            .opacity(animate ? 0.0 : 0.5)
            .animation(
                .easeOut(duration: 0.5),
                value: animate
            )
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundColor(Color.theme.red)
        .frame(width: 100, height: 100, alignment: .center)
}
