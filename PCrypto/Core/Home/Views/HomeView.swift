//
//  HomeView.swift
//  PCrypto
//
//  Created by Logycent on 20/12/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @State private var showPortfolio: Bool = false  // for right left animation
    @State private var showPortfolioView: Bool = false  // for new view popup

    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false

    @State private var showSettings: Bool = false

    var body: some View {
        ZStack {
            //background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(
                    isPresented: $showPortfolioView,
                    content: {
                        PortfolioView()
                            .environmentObject(homeVM)
                    }
                )
                .sheet(
                    isPresented: $showSettings,
                    content: {
                        SettingsView()
                    }
                )

            //content layer
            VStack {
                homeHeader

                HomeStatsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $homeVM.seachText)

                columnTitles

                if homeVM.allCoins.isEmpty {
                    loadingView
                } else {
                    if !showPortfolio {
                        allCoinsList
                            .transition(.move(edge: .leading))
                    }

                    if showPortfolio {
                        portfolioCoinsList
                            .transition(.move(edge: .trailing))
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() }
            )
        )
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettings.toggle()
                    }
                }

            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }.padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(homeVM.allCoins) { coin in
                CoinRowView(coin: coin, showHolding: false)
                    .listRowInsets(
                        .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(homeVM.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHolding: true)
                    .listRowInsets(
                        .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity(
                        (homeVM.sortOption == .rank
                            || homeVM.sortOption == .rankReversed ? 1.0 : 0)
                    )
                    .rotationEffect(
                        Angle(degrees: homeVM.sortOption == .rank ? 0 : 180))

            }
            .onTapGesture {
                withAnimation(.default) {
                    homeVM.sortOption =
                        homeVM.sortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (homeVM.sortOption == .holdings
                                || homeVM.sortOption == .holdingsReversed
                                ? 1.0 : 0)
                        )
                        .rotationEffect(
                            Angle(
                                degrees: homeVM.sortOption == .holdings
                                    ? 0 : 180)
                        )

                }
                .onTapGesture {
                    withAnimation(.default) {
                        homeVM.sortOption =
                            homeVM.sortOption == .holdings
                            ? .holdingsReversed : .holdings
                    }
                }
            }

            HStack {
                Image(systemName: "chevron.down")
                    .opacity(
                        (homeVM.sortOption == .price
                            || homeVM.sortOption == .priceReversed ? 1.0 : 0)
                    )
                    .rotationEffect(
                        Angle(degrees: homeVM.sortOption == .price ? 0 : 180))
                Text("Price")
            }
            .frame(
                width: UIScreen.main.bounds.width / 3,
                alignment: .trailing
            )
            .onTapGesture {
                withAnimation(.default) {
                    homeVM.sortOption =
                        homeVM.sortOption == .price ? .priceReversed : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 2.0)) {
                    homeVM.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }.rotationEffect(
                Angle(degrees: homeVM.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: Color.theme.accent)
                )
                .scaleEffect(2)
                .padding()
            Text("Loading coins...")
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background.opacity(0.8))
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreview.instance.homeVm)
}
