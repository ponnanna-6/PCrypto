//
//  HomeViewModel.swift
//  PCrypto
//
//  Created by Logycent on 21/12/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var statistics: [StatisticsModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var seachText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PorfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case holdings, holdingsReversed, price, priceReversed, rank, rankReversed
    }
    

    init() {
        addSubcribers()
    }

    func addSubcribers() {
        //Updates all coins since seacrh text and dataservice is combined
        $seachText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // wait for 0.5 seconds for fast typed letters
            .map(filterCoinsAndSort)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        //Update portfolio coins data
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(filterPortfolio)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        //Update market data
        marketDataService.$globalMarketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedData) in
                self?.statistics = returnedData
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.update(coin: coin, amount: amount)
    }
    
    func reloadData() {
        if !isLoading {
            isLoading = true
            coinDataService.getCoins()
        }
    }
    private func filterCoinsAndSort(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        let filteredCoins = filterCoins(text: text, coins: coins)
        let sortedCoins = sortCoins(coins: filteredCoins, sort: sort)
        return sortedCoins
    }
    

    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }

        let lowerCaseText = text.lowercased()

        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCaseText)
                || coin.symbol.lowercased().contains(lowerCaseText)
                || coin.id.lowercased().contains(lowerCaseText)
        }
        return filteredCoins
    }
    
    private func sortCoins(coins: [CoinModel], sort: SortOption) -> [CoinModel]{
        switch (sort) {
        case .rank, .holdings:
            return coins.sorted(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: {$0.rank > $1.rank})
        case .price:
            return coins.sorted(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
            return coins.sorted(by: {$0.currentPrice > $1.currentPrice})
        default:
            return coins
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketData = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map(\.currentHoldingsValue).reduce(0,+)
        
        let previousValue =
            portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = coin.priceChangePercentage24H ?? 0/100
                let previousValue = currentValue / (1+percentageChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue)/previousValue) * 100
        
        let portfolio = StatisticsModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        
        stats.append(contentsOf: [marketData, volume, btcDominance, portfolio])
        return stats
    }
    
    private func filterPortfolio(coinModels: [CoinModel] , portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        coinModels
            .compactMap {(coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinId == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
}
