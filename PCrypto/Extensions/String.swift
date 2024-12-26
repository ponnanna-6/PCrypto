//
//  String.swift
//  PCrypto
//
//  Created by Logycent on 26/12/2024.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
