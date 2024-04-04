//
//  PortfolioView.swift
//  Crypro
//
//  Created by Anton Petrov on 04.04.2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var quantityText: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding()
                    coinLogoList
                    if viewModel.selectedCoin != nil {
                        PortfolioTransactionView(quantityText: $quantityText)
                            .padding()
                            .animation(.none, value: UUID())
                    }
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading,
                    content: { CrossButton().environmentObject(viewModel) }
                )
            }
            .onChange(of: viewModel.searchText, perform: { value in
                if value.isEmpty {
                    viewModel.selectedCoin = nil
                }
            })
        }
    }
}

// MARK: - Components

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

// MARK: - Private Functions

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
