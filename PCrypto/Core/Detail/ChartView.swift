//
//  ChartView.swift
//  PCrypto
//
//  Created by Logycent on 26/12/2024.
//

import Charts
import SwiftUI

struct ChartView: View {
    @State private var selectedPoint: PricePoint?  // State to track the hovered point
    private var data: [Double]
    private var coin: CoinModel

    private let minValue: Double
    private let maxValue: Double
    private let lineColor: Color

    private let startingDate: Date
    private let endingDate: Date
    
    @State private var loadPercentage: CGFloat = 0

    init(coin: CoinModel) {
        self.coin = coin
        data = coin.sparklineIn7D?.price ?? []
        minValue = data.min() ?? 0
        maxValue = data.max() ?? 0

        lineColor =
            data[0] > data[data.count - 1] ? Color.theme.red : Color.theme.green
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }

    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(gridBackground)
                .overlay(chartYAxisLabels, alignment: .leading)
            
            chartXAxisLabels
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    loadPercentage = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
        .padding()
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition =
                        geometry.size.width / CGFloat(data.count)
                        * CGFloat(index + 1)

                    let yAxis = maxValue - minValue
                    let percentageY = CGFloat((data[index] - minValue) / yAxis)
                    let yPosition = (1 - percentageY) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: loadPercentage)
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
        }
    }

    private var gridBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxisLabels: some View {
        VStack {
            Text(maxValue.formattedWithAbbreviations())
            Spacer()
            Text(((maxValue + minValue) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minValue.formattedWithAbbreviations())
        }
        .font(.headline)
    }

    private var chartXAxisLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
