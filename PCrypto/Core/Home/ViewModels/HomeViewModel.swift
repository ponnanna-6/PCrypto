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

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PorfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubcribers()
    }

    func addSubcribers() {
        //Updates all coins since seacrh text and dataservice is combined
        $seachText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // wait for 0.5 seconds for fast typed letters
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //Update portfolio coins data
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(filterPortfolio)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //Update market data
        marketDataService.$globalMarketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedData) in
                self?.statistics = returnedData
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.update(coin: coin, amount: amount)
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
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, porfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketData = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        let porfolio = StatisticsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketData, volume, btcDominance, porfolio])
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
