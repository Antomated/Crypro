//
//  LinkView.swift
//  Crypro
//
//  Created by Anton Petrov on 20.04.2024.
//

import SwiftUI

struct LinkView: View {
    private let title: String
    private let url: URL

    init(title: String, url: URL) {
        print("DEBUG! url: \(url)")
        self.title = title
        self.url = url
    }

    var body: some View {
        Link(destination: url) {
            HStack(spacing: 0) {
                Image(systemName: "arrow.up.right.square")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color.theme.background)
                Text(title)
                    .padding(.leading, 6)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.theme.background)
            }
        }
        .padding(7)
        .padding(.horizontal, 6)
        .background(Capsule().fill(Color.theme.accent))
    }
}

#Preview {
    LinkView(title: LocalizationKey.website.localizedString,
             url: URL(string: Constants.twitterBaseUrl)!)
}
