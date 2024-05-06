//
//  CircleButtonView.swift
//  Crypro
//
//  Created by Anton Petrov on 01.04.2024.
//

import SwiftUI

struct CircleButtonView: View {
    let icon: SystemImage
    var body: some View {
        icon.image
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .strokeBorder(Color.theme.green, lineWidth: 2)
                    .background(Circle().fill(Color.theme.background))
            )
            .shadow(color: .green.opacity(1), radius: 5)
    }
}

#Preview {
    Group {
        CircleButtonView(icon: .plus)
            .previewLayout(.sizeThatFits)

        CircleButtonView(icon: .info)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
