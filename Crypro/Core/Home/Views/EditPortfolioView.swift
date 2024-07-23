//
//  EditPortfolioView.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import SwiftUI

struct EditPortfolioView: View {
    @StateObject var viewModel: EditPortfolioViewModel
    @FocusState private var searchIsFocused: Bool
    @State private var quantityText: String = ""
    @Environment(\.dismiss) var dismiss

    init(coin: Coin? = nil, allCoins: [Coin]) {
        let state = SelectedCoinState()
        state.selectedCoin = coin
        _viewModel = StateObject(wrappedValue: EditPortfolioViewModel.init(sharedState: state, allCoins: allCoins))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding()
                        .focused($searchIsFocused)
                    coinLogoList
                    if viewModel.selectedCoinState.selectedCoin != nil {
                        PortfolioTransactionView(viewModel: PortfolioTransactionViewModel(sharedState: viewModel.selectedCoinState),
                                                 quantityText: $quantityText)
                            .padding()
                            .animation(.none, value: UUID())
                    }
                }
                .background(Color.theme.background.ignoresSafeArea())
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(LocalizationKey.editPortfolio.localizedString)
                            .font(.chakraPetch(.bold, size: 24))
                    }
                    ToolbarItem(
                        placement: .topBarTrailing,
                        content: {
                            Button {
                                dismiss()
                                viewModel.selectedCoinState.selectedCoin = nil
                            } label: {
                                SystemImage.xMark.image
                                    .bold()
                            }
                            .foregroundColor(.theme.accent)
                        }
                    )
                }
                .onChange(of: viewModel.searchText, perform: { value in
                    if value.isEmpty {
                        viewModel.selectedCoinState.selectedCoin = nil
                    }
                })
                .animation(.easeOut(duration: 0.16), value: UUID())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if let coin = viewModel.selectedCoinState.selectedCoin {
                updateSelectedCoin(coin: coin)
                viewModel.searchText = coin.name
                searchIsFocused = false
            }
        }
        .onDisappear {
            viewModel.searchText = ""
        }
    }
}

// MARK: - UI Components

private extension EditPortfolioView {
    private var searchListCoins: [Coin] {
        viewModel.searchText.isEmpty && !viewModel.portfolioCoins.isEmpty
            ? viewModel.portfolioCoins
            : viewModel.allCoins
    }

    var coinLogoList: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(searchListCoins) { coin in
                        CoinLogoView(coin: coin)
                            .frame(width: 75)
                            .padding(4)
                            .id(coin.id)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    updateSelectedCoin(coin: coin)
                                    searchIsFocused = false
                                    scrollView.scrollTo(coin.id, anchor: .center)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        (viewModel.selectedCoinState.selectedCoin?.id == coin.id)
                                            ? Color.theme.green
                                            : Color.clear
                                    )
                            )
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading)
            }
            .onAppear {
                print("DEBUG! viewModel.selectedCoinState.selectedCoin?.id: \(viewModel.selectedCoinState.selectedCoin?.id)")
                if let selectedCoinID = viewModel.selectedCoinState.selectedCoin?.id {
                    scrollView.scrollTo(selectedCoinID, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Private methods

private extension EditPortfolioView {
    func updateSelectedCoin(coin: Coin) {
        viewModel.selectedCoinState.selectedCoin = coin
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
}

// TODO:  fix

//#Preview {
//    EditPortfolioView()
//        .environmentObject(HomeViewModel())
//}
