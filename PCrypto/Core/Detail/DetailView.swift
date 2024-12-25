//
//  DetailView.swift
//  PCrypto
//
//  Created by Logycent on 25/12/2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?

    //to initialize view before coming here
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }

    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

struct DetailView: View {

    @StateObject private var vm: DetailViewModel

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private let spacing: CGFloat = 30

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("")
                    .frame(height: 150)
                
                overview
                
                additionalDetails

            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    private var overview: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: spacing,
                content: {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticsView(stat: stat)
                    }
                })
        }
    }

    private var additionalDetails: some View {
        VStack {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: spacing,
                content: {
                    ForEach(vm.additionalStatistics) { stat in
                        StatisticsView(stat: stat)
                    }
                })
        }
    }
}
