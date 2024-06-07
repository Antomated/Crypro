//
//  PortfolioTransactionView.swift
//  Crypro
//
//  Created by Beavean on 04.04.2024.
//

import SwiftUI

struct PortfolioTransactionView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var quantityText: String
    @FocusState var quantityIsFocused: Bool

    private var currentValue: Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (viewModel.selectedCoin?.currentPrice ?? 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
            coinDetailStatView
            coinInputAmountView
            saveButtonView
        }
    }
}

// MARK: - UI Components

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
            Text("= \(currentValue.asCurrencyWith2Decimals())")
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

// MARK: - Private methods

private extension PortfolioTransactionView {
    func updatePortfolio() {
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
