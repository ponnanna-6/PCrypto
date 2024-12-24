//
//  StatisticsModel.swift
//  PCrypto
//
//  Created by Logycent on 24/12/2024.
//

import Foundation

struct StatisticsModel: Identifiable {
    let id: String
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.id = UUID().uuidString
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
