//
//  DetailViewModel.swift
//  PCrypto
//
//  Created by Logycent on 25/12/2024.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    @Published var coin: CoinModel

    @Published var additionalStatistics: [StatisticsModel] = []
    @Published var overviewStatistics: [StatisticsModel] = []

    @Published var coinData: [CoinDetailModel] = []
    @Published var coinDetailed: CoinDetailModel?
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let coinDetailDataService: CoinDetailDataService

    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubcribers()
    }

    func addSubcribers() {
        //Updates all coins since seacrh text and dataservice is combined
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(processData)
            .sink { [weak self] (returnedData) in
                self?.overviewStatistics = returnedData.overview
                self?.additionalStatistics = returnedData.additional
            }
            .store(in: &cancellables)
        
        //For coin description and URL's
        coinDetailDataService.$coinDetails
            .sink { [weak self] (returnedData) in
                self?.coinDescription = returnedData?.readableDescription
                self?.websiteURL = returnedData?.links?.homepage?.first
                self?.redditURL = returnedData?.links?.subredditURL
            }
            .store(in: &cancellables)
    }

    func processData(coinDetailData: CoinDetailModel?, coin: CoinModel?) -> (
        overview: [StatisticsModel], additional: [StatisticsModel]
    ) {
        guard let coinDetailData = coinDetailData, let coin = coin else {
            // Return default or empty data if inputs are nil
            return (overview: [], additional: [])
        }
        
        //Overview Coin Details
        let overview: [StatisticsModel] = getOverviewStats(coin: coin)

        //Additional Coin Details
        let additional: [StatisticsModel] = getAdditionalStats(coin: coin, coinDetail: coinDetailData)

        return (overview, additional)
    }
    
    private func getOverviewStats(coin: CoinModel) -> [StatisticsModel] {
        let priceStat =
            StatisticsModel(
                title: "Current Price",
                value: coin.currentPrice.asCurrencyWith6Decimals(),
                percentageChange: coin.priceChangePercentage24H
            )

        let marketStat =
            StatisticsModel(
                title: "Market Cap",
                value: "$"
                    + (coin.marketCap?.formattedWithAbbreviations() ?? ""),
                percentageChange: coin.marketCapChange24H
            )

        let rankStat =
            StatisticsModel(title: "Rank", value: "\(coin.rank)")
        
        let volumeStat =
            StatisticsModel(
                title: "Volume",
                value: "$"
                + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
            )
        return [priceStat, marketStat, rankStat, volumeStat]
    }
    
    private func getAdditionalStats(coin: CoinModel, coinDetail: CoinDetailModel) -> [StatisticsModel] {
        let highStat =
            StatisticsModel(
                title: "24h High",
                value: coin.high24H?.asCurrencyWith6Decimals() ?? "N/A"
            )

        let lowStat =
            StatisticsModel(
                title: "24h Low",
                value: coin.low24H?.asCurrencyWith6Decimals() ?? "N/A"
            )
        
        let priceChangeStat =
            StatisticsModel(
                title: "24h Price Change",
                value: (coin.priceChange24H?.asCurrencyWith6Decimals() ?? ""),
                percentageChange: coin.priceChangePercentage24H
            )
        
        let marketChangeStat =
        StatisticsModel(
            title: "24h Market Change",
            value: "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? ""),
            percentageChange: coin.marketCapChangePercentage24H
        )
        
        let blockTimeStat = StatisticsModel(title: "Block Time", value: "\(coinDetail.blockTimeInMinutes ?? 0)")
        
        let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: coinDetail.hashingAlgorithm ?? "")
        
        return [highStat, lowStat, priceChangeStat, marketChangeStat, blockTimeStat, hashingStat]
    }
}
