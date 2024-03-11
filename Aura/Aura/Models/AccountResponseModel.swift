//
//  TransactionModel.swift
//  Aura
//
//  Created by Greg on 26/02/2024.
//

import SwiftUI

struct AccountResponse: Codable {
    let currentBalance: Decimal
    let transactions: [Transaction]
}

extension AccountResponse {
    struct Transaction: Codable {
        let value: Decimal
        let label: String
    }
}
