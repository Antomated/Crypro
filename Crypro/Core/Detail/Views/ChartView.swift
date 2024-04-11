//
//  ChartView.swift
//  Crypro
//
//  Created by Anton Petrov on 12.04.2024.
//
// TODO: Update chart UI

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0

    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red

        endingDate = Date(dateString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }

    var body: some View {
        VStack {
            chartDateLabels
                .padding(.vertical, 12)
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(
                    chartYAxis
                        .padding(.horizontal, 4)
                        .font(.caption2)
                    , alignment: .leading
                )
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1)) {
                    percentage = 1.0
                }
            }
        }
    }
}

private extension ChartView {
    var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)

                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat(data[index] - minY) / yAxis) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 9, y: 10)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 9, y: 20)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 9, y: 30)
        }
    }

    var chartBackground: some View {
        VStack {
            ForEach(0..<9) { _ in
                Divider()
                Spacer()
            }
            Divider()
        }
    }

    var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
                .padding(2)
                .background(
                    Capsule()
                        .fill(Color.theme.background.opacity(0.85))
                )
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
                .padding(2)
                .background(
                    Capsule()
                        .fill(Color.theme.background.opacity(0.85))
                )
            Spacer()
            Text(minY.formattedWithAbbreviations())
                .padding(2)
                .background(
                    Capsule()
                        .fill(Color.theme.background.opacity(0.85))
                )
        }
        .foregroundStyle(Color.theme.accent)
    }

    var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text("7 days chart")
            Spacer()
            Text(endingDate.asShortDateString())
        }
        .padding(8)
        .padding(.horizontal, 4)
        .background(Color.theme.secondaryText.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    ChartView(coin: Coin.coin)
        .preferredColorScheme(.dark)
}
