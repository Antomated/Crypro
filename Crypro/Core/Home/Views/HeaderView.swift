//
//  HeaderView.swift
//  Crypro
//
//  Created by Beavean on 19.06.2024.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showPortfolio: Bool
    private let projectURL = URL(string: Constants.projectURL)!
    private let coinGeckoURL = URL(string: Constants.coinGeckoURL)!

    var body: some View {
        HStack(alignment: .bottom) {
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
            .font(.chakraPetch(.bold, size: 24))
            .tracking(4)
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
}

#Preview {
    HeaderView(showPortfolio: .constant(true))
}
