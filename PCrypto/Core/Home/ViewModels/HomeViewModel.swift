//
//  HomeViewModel.swift
//  PCrypto
//
//  Created by Logycent on 21/12/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let coinDataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
        addSubcribers()
    }
    
    func addSubcribers() {
        coinDataService.$allCoins
            .sink {[weak self](returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
