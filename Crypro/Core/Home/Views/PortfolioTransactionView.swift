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

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            nameSection
            Divider()
            coinDetailStatView
            Divider()
            coinInputAmountView
            saveButtonView
        }
    }
}

// MARK: - COMPONENTS

private extension PortfolioTransactionView {
    var nameSection: some View {
        HStack {
            Text(viewModel.selectedCoin?.name.uppercased() ?? "")
                .bold()
                .font(.title2)
            Text(viewModel.selectedCoin?.symbol.uppercased() ?? "")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Spacer()
        }
    }

    var coinDetailStatView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.detailStatistics) { stat in
                    // TODO: Statistic details
                }
            }
            .frame(maxHeight: 60)
        }
    }

    var coinInputAmountView: some View {
        HStack {
            TextField("Amount holding...", text: $quantityText)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(12)
                .frame(width: UIScreen.main.bounds.width / 1.9)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.theme.secondaryText)
                )
                .keyboardType(.decimalPad)
            Text("= \(getCurrentValue().asCurrencyWith2Decimals())")
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
            saveButtonPressed()
        } label: {
            Text("Save")
                .foregroundStyle(Color.theme.background)
                .padding()
                .frame(maxWidth: .infinity)
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
        guard
            let coin = viewModel.selectedCoin,
            let amount = Double(quantityText)
        else { return }

        // save to portfolio
        viewModel.updatePortfolio(coin: coin, amount: amount)

        // update fields
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }

        UIApplication.shared.endEditing()
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
