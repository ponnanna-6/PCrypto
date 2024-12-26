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
    @State private var showFullDescription: Bool = false
    @State private var showLoading: Bool = true

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
            if showLoading {
                loadingView
            } else {
                VStack(spacing: 10) {
                    ChartView(coin: vm.coin)
                    overviewTitle
                    Divider()
                    coinDescription
                    overview
                    
                    additionalTitle
                    Divider()
                    additionalDetails
                    
                    Divider()
                    websiteSection
                }
                .padding()
            }
        }

        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
        .onAppear {
            // Show loading view for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showLoading = false
            }
        }
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
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: spacing,
                content: {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticsView(stat: stat)
                    }
                })
        }
    }

    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalDetails: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: spacing,
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticsView(stat: stat)
                }
            })
    }

    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)

        }
    }

    private var coinDescription: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
                !coinDescription.isEmpty
            {
                VStack(alignment: .leading) {
                    Text(coinDescription.removingHTMLOccurances)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button(
                        action: {
                            withAnimation(.easeInOut) {
                                showFullDescription.toggle()
                            }
                        },
                        label: {
                            Text(
                                showFullDescription ? "Less ^" : "Read more..."
                            )
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 4)
                        }
                    )
                    .accentColor(.blue)
                }
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .center){
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            Divider()
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .font(.title)
        .bold()
        .foregroundColor(.blue)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: Color.theme.accent)
                )
                .scaleEffect(2)
                .padding()
            Text("Loading data...")
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.theme.background.opacity(0.8))
    }
}
