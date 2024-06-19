//
//  DetailView.swift
//  Crypro
//
//  Created by Beavean on 06.04.2024.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var showLoader: Bool = true
    @State private var startAnimation: Bool = false
    @State private var showFullDescription: Bool = false
    @State private var showPortfolioView: Bool = false

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 20

    init(coin: Coin) {
        _viewModel = .init(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin, startAnimation: $startAnimation)
                    .padding(.horizontal)
                    .padding(.vertical)
                VStack(spacing: 16) {
                    linkSection
                    overviewHeader
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalHeader
                    Divider()
                    additionalGrid
                }
                .padding()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(viewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
        .overlay(
            Group {
                detailFooter
                if showLoader {
                    LoaderView()
                        .ignoresSafeArea()
                }
            }
                .animation(.easeInOut, value: showLoader)
                .transition(.opacity)
        )
        .onReceive(viewModel.$hasLoadedData) { hasLoadedData in
            showLoader = !hasLoadedData
            startAnimation = hasLoadedData
        }
        .sheet(isPresented: $showPortfolioView, content: {
            PortfolioView(coin: viewModel.coin)
        })
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text(LocalizationKey.errorTitle.localizedString),
                message: Text(error.message),
                dismissButton: .default(
                    Text(LocalizationKey.okButton.localizedString),
                    action: {
                        viewModel.error = nil
                    }
                )
            )
        }
    }
}

// MARK: - UI Components

private extension DetailView {
    var overviewHeader: some View {
        getStatDetailsHeader(with: LocalizationKey.overview.localizedString)
    }

    var additionalHeader: some View {
        getStatDetailsHeader(with: LocalizationKey.additionalDetails.localizedString)
    }

    var overviewGrid: some View {
        getStatDetail(with: viewModel.overviewStatistics)
    }

    var additionalGrid: some View {
        getStatDetail(with: viewModel.additionalStatistics)
    }

    var navigationBarTrailingItems: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }

    var descriptionSection: some View {
        ZStack {
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? .max : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    Button {
                        showFullDescription.toggle()
                    } label: {
                        Text(showFullDescription
                             ? LocalizationKey.collapse.localizedString
                             : LocalizationKey.readMore.localizedString)
                    }
                    .tint(.theme.green)
                    .font(.footnote.weight(.bold))
                    .padding(.vertical, 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.none, value: showFullDescription)
            }
        }
    }

    var linkSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let homeURL = viewModel.websiteURL,
                   let url = URL(string: homeURL) {
                    LinkView(title: LocalizationKey.website.localizedString, url: url)
                }
                if let twitterURL = viewModel.twitterURL,
                   let url = URL(string: twitterURL) {
                    LinkView(title: LocalizationKey.twitter.localizedString, url: url)
                }
                if let telegramURL = viewModel.telegramURL,
                   let url = URL(string: telegramURL) {
                    LinkView(title: LocalizationKey.telegram.localizedString, url: url)
                }
                if let redditURL = viewModel.redditURL,
                   let url = URL(string: redditURL) {
                    LinkView(title: LocalizationKey.reddit.localizedString, url: url)
                }
                Spacer()
            }
        }
    }

    var detailFooter: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    CircleButtonView(icon: .plus)
                        .animation(.none, value: showPortfolioView)
                        .onTapGesture {
                            HapticManager.triggerSelection()
                            showPortfolioView.toggle()
                        }
                }
                .frame(maxWidth: 60, maxHeight: 60)
            }
            .padding(24)
        }
        .ignoresSafeArea()
    }

}

// MARK: - Private methods

private extension DetailView {
    func getStatDetailsHeader(with title: String) -> some View {
        Text(title)
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func getStatDetail(with stat: [Statistic]) -> some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(stat) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: CoinsStubs.bitcoin)
            .preferredColorScheme(.dark)
    }
}
