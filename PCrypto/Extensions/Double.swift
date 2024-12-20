//
//  Double.swift
//  PCrypto
//
//  Created by Logycent on 21/12/2024.
//

import Foundation

extension Double {
    /// Converts a double to currency of 2-6 decimal places
    private var currencyFormater6: NumberFormatter {
        let formater = NumberFormatter()
        formater.usesGroupingSeparator = true
        formater.numberStyle = .currency
        formater.locale = .current
        formater.currencyCode = "INR"
        formater.currencySymbol = "₹"
        formater.minimumFractionDigits = 2
        formater.maximumFractionDigits = 6
        return formater
    }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormater6.string(from: number) ?? "₹0.00"
    }
    
    private var currencyFormater2: NumberFormatter {
        let formater = NumberFormatter()
        formater.usesGroupingSeparator = true
        formater.numberStyle = .currency
        formater.locale = .current
        formater.currencyCode = "INR"
        formater.currencySymbol = "₹"
        formater.minimumFractionDigits = 2
        formater.maximumFractionDigits = 2
        return formater
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormater2.string(from: number) ?? "₹0.00"
    }
    
    func asNumberString2Places() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentage() -> String {
        return asNumberString2Places() + "%"
    }
}
