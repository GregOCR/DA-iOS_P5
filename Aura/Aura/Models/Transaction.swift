//
//  Transaction.swift
//  Aura
//
//  Created by Greg on 11/03/2024.
//

import SwiftUI

class Transaction: ObservableObject {
    @Published var value: Decimal = 0
    @Published var label: String = ""
}
