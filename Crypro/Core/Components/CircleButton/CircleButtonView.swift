//
//  CircleButtonView.swift
//  Crypro
//
//  Created by Anton Petrov on 01.04.2024.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .strokeBorder(ColorTheme().green, lineWidth: 2)
                    .background(Circle().fill(ColorTheme().background))
            )
            .shadow(color: .green.opacity(1), radius: 5)
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "plus")
            .previewLayout(.sizeThatFits)

        CircleButtonView(iconName: "info")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
