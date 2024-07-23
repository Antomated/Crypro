//
//  PortfolioTransactionView.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import SwiftUI

struct PortfolioTransactionView: View {
    @StateObject var viewModel: PortfolioTransactionViewModel
    @Binding var quantityText: String
    @FocusState var quantityIsFocused: Bool

    private var currentValue: Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (viewModel.sharedState.selectedCoin?.currentPrice ?? 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            coinDetailStatisticsView
            coinInputAmountView
            saveButtonView
        }
    }
}

// MARK: - UI Components

private extension PortfolioTransactionView {
    var coinDetailStatisticsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.detailStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
            .frame(maxHeight: 54)
        }
    }

    var coinInputAmountView: some View {
        HStack {
            TextField(LocalizationKey.amountHolding.localizedString, text: $quantityText)
                .font(.chakraPetch(.medium, size: 14))
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.theme.accent)
                )
                .keyboardType(.decimalPad)
                .focused($quantityIsFocused)
            Text("= \(currentValue.asCurrencyWith2Decimals())")
                .font(.chakraPetch(.medium, size: 15))
                .padding(12)
                .lineLimit(1)
                .foregroundStyle(Color.theme.accent)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.theme.accent)
                )
        }
    }

    var saveButtonView: some View {
        Button {
            updatePortfolio()
        } label: {
            Text(LocalizationKey.saveButton.localizedString)
                .foregroundStyle(Color.theme.background)
                .font(.chakraPetch(.bold, size: 20))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.green)
                )
        }
        .disabled(quantityText.isEmpty ? true : false)
    }
}

// MARK: - Private methods

private extension PortfolioTransactionView {
    func updatePortfolio() {
        guard let coin = viewModel.sharedState.selectedCoin,
              let amount = Double(quantityText)
        else { return }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }
        quantityIsFocused = false
    }

    func removeSelectedCoin() {
        viewModel.sharedState.selectedCoin = nil
        quantityText = ""
        viewModel.searchText = ""
    }
}

// TODO: fix
//#Preview {
//    PortfolioTransactionView(viewModel: PortfolioTransactionViewModel(selectedCoin: CoinsStubs.bitcoin),
//                             quantityText: .constant(""))
//}
