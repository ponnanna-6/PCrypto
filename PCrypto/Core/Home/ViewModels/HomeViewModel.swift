//
//  HomeViewModel.swift
//  PCrypto
//
//  Created by Logycent on 21/12/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticsModel] = [
        StatisticsModel(title: "MArket cap", value: "$2.5tr", percentageChange: 0.7)
    ]
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var seachText: String = ""

    private let coinDataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
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
}
