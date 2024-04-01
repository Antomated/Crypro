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
            .scale(animate ? 1.2 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(
                animate ? Animation.easeOut(duration: 1.0) : .none,
                value: animate
            )
            .onAppear {
                animate.toggle()
            }
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundColor(.red)
        .frame(width: 100, height: 100, alignment: .center)
}
