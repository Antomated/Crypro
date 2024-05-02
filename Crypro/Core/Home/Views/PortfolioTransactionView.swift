//
//  PortfolioTransactionView.swift
//  Crypro
//
//  Created by Anton Petrov on 04.04.2024.
//

import SwiftUI

struct PortfolioTransactionView: View {

    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var quantityText: String
    @FocusState var quantityIsFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
            coinDetailStatView
            coinInputAmountView
            saveButtonView
        }
    }
}

// MARK: - COMPONENTS

private extension PortfolioTransactionView {
    var coinDetailStatView: some View {
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
                .font(.callout)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.theme.accent)
                )
                .keyboardType(.decimalPad)
                .focused($quantityIsFocused)
            Text("= \(getCurrentValue().asCurrencyWith2Decimals())")
                .padding(12)
                .layoutPriority(1)
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
            saveButtonPressed()
        } label: {
            Text(LocalizationKey.saveButton.localizedString)
                .foregroundStyle(Color.theme.background)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.accent)
                )
        }
        .disabled(quantityText.isEmpty ? true : false)
    }
}

// MARK: - PRIVATE METHODS

private extension PortfolioTransactionView {
    func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (viewModel.selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    func saveButtonPressed() {
        guard let coin = viewModel.selectedCoin,
              let amount = Double(quantityText)
        else { return }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }
        quantityIsFocused = false
    }

    func removeSelectedCoin() {
        viewModel.selectedCoin = nil
        quantityText = ""
        viewModel.searchText = ""
    }
}

#Preview {
    PortfolioTransactionView(quantityText: .constant(""))
        .environmentObject(HomeViewModel())
}
