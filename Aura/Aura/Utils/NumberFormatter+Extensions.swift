//
//  NumberFormatter+Extensions.swift
//  Aura
//
//  Created by Greg on 11/03/2024.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        return formatter
    }()
}
