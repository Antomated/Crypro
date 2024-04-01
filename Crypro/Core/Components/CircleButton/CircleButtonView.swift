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
            .foregroundColor(.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(.background)
            )
            .shadow(color: .accent.opacity(0.25),
                    radius: 10, x: 0, y: 0)
            .padding()
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
