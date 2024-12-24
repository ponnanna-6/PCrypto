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
        formater.currencyCode = "USD"
        formater.currencySymbol = "$"
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
        formater.currencyCode = "USD"
        formater.currencySymbol = "$"
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
    
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString2Places()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString2Places()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString2Places()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString2Places()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString2Places()

        default:
            return "\(sign)\(self)"
        }
    }
}
