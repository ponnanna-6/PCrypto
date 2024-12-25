//
//  HomeView.swift
//  PCrypto
//
//  Created by Logycent on 20/12/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @State private var showPortfolio: Bool = false // for right left animation
    @State private var showPortfolioView: Bool = false // for new view popup
    
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

            //content layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $homeVM.seachText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
               }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
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
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(homeVM.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHolding: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coins")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreview.instance.homeVm)
}
