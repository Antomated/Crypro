//
//  HeaderView.swift
//  Crypro
//
//  Created by Anton Petrov on 19.06.2024.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showPortfolio: Bool
    private let projectURL = URL(string: Constants.projectURL)!
    private let coinGeckoURL = URL(string: Constants.coinGeckoURL)!

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Link(destination: projectURL) {
                    Image(.logo)
                        .resizable()
                        .frame(width: 40, height: 40)
            }
            Spacer()
            Text(showPortfolio
                 ? LocalizationKey.portfolio.localizedString
                 : LocalizationKey.livePrices.localizedString)
            .font(.title3.weight(.heavy))
            .foregroundStyle(Color.theme.accent)
            .animation(.none, value: showPortfolio)
            .padding(.top)
            .frame(maxWidth: .infinity)
            Spacer()
            Link(destination: coinGeckoURL) {
                Image(.coinGeckoLogo)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Spacer()
        }
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    HeaderView(showPortfolio: .constant(true))
}
