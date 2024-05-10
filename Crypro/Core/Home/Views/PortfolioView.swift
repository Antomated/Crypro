//
//  PortfolioView.swift
//  Crypro
//
//  Created by Beavean on 04.04.2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @FocusState private var searchIsFocused: Bool
    @State private var quantityText: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding()
                        .focused($searchIsFocused)
                    coinLogoList
                    if viewModel.selectedCoin != nil {
                        PortfolioTransactionView(quantityText: $quantityText)
                            .padding()
                            .animation(.none, value: UUID())
                    }
                }
                .background(Color.theme.background.ignoresSafeArea())
                .navigationTitle(LocalizationKey.editPortfolio.localizedString)
                .toolbar {
                    ToolbarItem(
                        placement: .topBarLeading,
                        content: {
                            Button {
                                dismiss()
                                viewModel.selectedCoin = nil
                            } label: {
                                SystemImage.xMark.image
                                    .font(.headline)
                            }
                            .foregroundColor(.theme.accent)
                        }
                    )
                }
                .onChange(of: viewModel.searchText, perform: { value in
                    if value.isEmpty {
                        viewModel.selectedCoin = nil
                    }
                })
                .animation(.easeOut(duration: 0.16), value: UUID())
            }
        }
    }
}

// MARK: - UI Components

private extension PortfolioView {
    private var searchListCoins: [Coin] {
        viewModel.searchText.isEmpty && !viewModel.portfolioCoins.isEmpty
            ? viewModel.portfolioCoins
            : viewModel.allCoins
    }

    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(searchListCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                                searchIsFocused = false
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    (viewModel.selectedCoin?.id == coin.id)
                                        ? Color.theme.green
                                        : Color.clear
                                )
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
}

// MARK: - Private methods

private extension PortfolioView {
    func updateSelectedCoin(coin: Coin) {
        viewModel.selectedCoin = coin

        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}
