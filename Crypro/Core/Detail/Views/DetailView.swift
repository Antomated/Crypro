//
//  DetailView.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {

    @StateObject private var viewModel: DetailViewModel
    @State private var showFullDescription: Bool = false

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
                ChartView(coin: viewModel.coin)
                    .padding(.horizontal)
                    .padding(.vertical)
                VStack(spacing: 16) {
                    overviewHeader
                    linkSection
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
    }
}

// MARK: - COMPONENTS

private extension DetailView {
    var overviewHeader: some View {
        getStatDetailsHeader(with: "Overview")
    }

    var additionalHeader: some View {
        getStatDetailsHeader(with: "Additional Details")
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
                        Text(showFullDescription ? "Collapse ↑" : "Read more ↓")
                    }
                    .tint(ColorTheme().green)
                    .font(.footnote.weight(.bold))
                    .padding(.vertical, 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.none, value: showFullDescription)
            }
        }
    }

    // TODO: Caseiterable enum
    var linkSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let homeURL = viewModel.websiteURL,
                   let url = URL(string: homeURL) {
                    LinkView(title: "Home", url: url)
                }
                if let twitterURL = viewModel.twitterURL,
                   let url = URL(string: twitterURL) {
                    LinkView(title: "Twitter", url: url)
                }
                if let telegramURL = viewModel.telegramURL,
                   let url = URL(string: telegramURL) {
                    LinkView(title: "Telegram", url: url)
                }
                if let redditURL = viewModel.redditURL,
                   let url = URL(string: redditURL) {
                    LinkView(title: "Reddit", url: url)
                }
                Spacer()
            }
        }
    }
}

// MARK: - PRIVATE METHODS

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
            pinnedViews: []) {
                ForEach(stat) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: Development.coin)
            .preferredColorScheme(.dark)
    }
}
