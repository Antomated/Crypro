//
//  CircleButtonView.swift
//  Crypro
//
//  Created by Beavean on 01.04.2024.
//

import SwiftUI

struct CircleButtonView: View {
    let icon: SystemImage

    var body: some View {
        icon.image
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .bold()
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

        CircleButtonView(icon: .chevronRight)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
