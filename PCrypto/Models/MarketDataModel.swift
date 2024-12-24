//
//  MarketDataModel.swift
//  PCrypto
//
//  Created by Logycent on 24/12/2024.
//

import Foundation
/*
 URL: "https://api.coingecko.com/api/v3/global"
 
 JSON Response: {
 "data": {
   "active_cryptocurrencies": 16268,
   "upcoming_icos": 0,
   "ongoing_icos": 49,
   "ended_icos": 3376,
   "markets": 1197,
   "total_market_cap": {
     "btc": 36550176.680850916,
     "eth": 1026183723.274545,
   },
   "total_volume": {
     "btc": 1971432.2437213855,
     "eth": 55349983.60501505,
   },
   "market_cap_percentage": {
     "btc": 54.17361774443557,
     "eth": 11.738652066826525,
   },
   "market_cap_change_percentage_24h_usd": 4.676949348789399,
   "updated_at": 1735056672
 }
}
*/

struct GlobalDataModel: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentage()
        }
        return ""
    }
    
}
