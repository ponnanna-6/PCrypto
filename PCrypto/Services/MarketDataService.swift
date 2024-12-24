//
//  MarketDataService.swift
//  PCrypto
//
//  Created by Logycent on 24/12/2024.
//

import Foundation
import Combine

class MarketDataService {
    @Published var globalMarketData: MarketDataModel? = nil
    var marketSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    private func getMarketData () {
        guard let url = URL(string:"https://api.coingecko.com/api/v3/global") else {return}
        
        marketSubscription =  NetworkingManger.download(url: url)
            .decode(type: GlobalDataModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManger.handleCompletion , receiveValue: { [weak self] (returnedData) in
                self?.globalMarketData = returnedData.data
                self?.marketSubscription?.cancel()
            })
    }
}
