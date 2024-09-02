//
//  EditPortfolioView.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import Combine
import SwiftUI

struct EditPortfolioView: View {
    @StateObject var viewModel: EditPortfolioViewModel
    @FocusState private var searchIsFocused: Bool
    @State private var quantityText: String = ""
    @Environment(\.dismiss) var dismiss
    @FocusState var quantityIsFocused: Bool
    private let singleCoinDisplay: Bool

    private var showsPortfolio: Bool {
        viewModel.searchText.isEmpty && !viewModel.portfolioCoins.isEmpty
    }

    private var searchListCoins: [Coin] {
        showsPortfolio ? viewModel.portfolioCoins : viewModel.filteredCoins
    }

    private var currentValue: Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (viewModel.selectedCoin?.currentPrice ?? 0)
    }

    init(
        allCoins: [Coin],
        portfolioDataService: PortfolioDataServiceProtocol,
        coinImageService: CoinImageServiceProtocol
    ) {
        _viewModel = StateObject(wrappedValue: EditPortfolioViewModel(selectedCoin: nil,
                                                                      allCoins: allCoins,
                                                                      portfolioDataService: portfolioDataService,
                                                                      coinImageService: coinImageService))
        singleCoinDisplay = false
    }

    init(
        singleCoin: Coin,
        portfolioDataService: PortfolioDataServiceProtocol,
        coinImageService: CoinImageServiceProtocol
    ) {
        _viewModel = StateObject(wrappedValue: EditPortfolioViewModel(selectedCoin: singleCoin,
                                                                      allCoins: [singleCoin],
                                                                      portfolioDataService: portfolioDataService,
                                                                      coinImageService: coinImageService))
        singleCoinDisplay = true
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if !singleCoinDisplay {
                        SearchBarView(searchText: $viewModel.searchText)
                            .padding()
                            .focused($searchIsFocused)
                    }
                    coinLogoList
                    if viewModel.selectedCoin != nil {
                        VStack(alignment: .leading, spacing: 16) {
                            Divider()
                            coinDetailStatisticsView
                            coinInputAmountView
                            saveButtonView
                        }
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
                                viewModel.selectedCoin = nil
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
                        viewModel.selectedCoin = nil
                    }
                })
                .animation(.easeOut(duration: 0.16), value: UUID())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if let coin = viewModel.selectedCoin {
                updateSelectedCoin(coin: coin)
                viewModel.searchText = coin.name
                searchIsFocused = false
            }
            if singleCoinDisplay {
                quantityIsFocused = true
            }
        }
        .onDisappear {
            viewModel.searchText = ""
        }
    }
}

// MARK: - UI Components

private extension EditPortfolioView {
    var coinLogoList: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(searchListCoins) { coin in
                        CoinLogoView(coin: coin, coinImageService: viewModel.coinImageService)
                            .frame(width: 75)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
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
                                        (viewModel.selectedCoin?.id == coin.id)
                                            ? Color.theme.green
                                            : Color.clear
                                    )
                            )
                    }
                }
                .padding(.leading)
            }
            .onAppear {
                if let selectedCoinID = viewModel.selectedCoin?.id {
                    scrollView.scrollTo(selectedCoinID, anchor: .center)
                }
            }
            .onChange(of: viewModel.filteredCoins) { _ in
                withAnimation(.smooth) {
                    if !showsPortfolio, let firstCoinID = viewModel.filteredCoins.first?.id {
                        scrollView.scrollTo(firstCoinID, anchor: .leading)
                    } else if let firstPortfolioCoinId = viewModel.portfolioCoins.first?.id {
                        scrollView.scrollTo(firstPortfolioCoinId, anchor: .leading)
                    }
                }
            }
        }
    }

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
                .onReceive(Just(quantityText)) { newValue in
                    let filtered = viewModel.formatQuantityText(newValue, currentValue: currentValue)
                    if filtered != newValue {
                        self.quantityText = filtered
                    }
                }
            Text("= \(currentValue.asCurrencyWithAbbreviations())")
                .font(.chakraPetch(.medium, size: 15))
                .padding(12)
                .lineLimit(1)
                .foregroundStyle(Color.theme.accent)
                .frame(minWidth: 120)
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

private extension EditPortfolioView {
    func updateSelectedCoin(coin: Coin) {
        viewModel.selectedCoin = coin
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }

    func updatePortfolio() {
        guard let coin = viewModel.selectedCoin,
              let amount = Double(quantityText)
        else { return }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }
        quantityIsFocused = false
        if singleCoinDisplay {
            dismiss()
        }
    }

    func removeSelectedCoin() {
        viewModel.selectedCoin = nil
        quantityText = ""
        viewModel.searchText = ""
    }
}

#Preview {
    EditPortfolioView(singleCoin: CoinsStubs.bitcoin,
                      portfolioDataService: PortfolioDataService(),
                      coinImageService: CoinImageService(networkManager: NetworkManager(),
                                                         imageDataProvider: ImageDataProvider()))
}
