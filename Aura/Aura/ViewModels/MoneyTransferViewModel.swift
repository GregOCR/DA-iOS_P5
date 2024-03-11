//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

class MoneyTransferViewModel: ObservableObject {
    
    @Published var recipient: String = ""
    @Published var amount: Float = 0.0
    
    @Published var transferMessage: String = ""
    
    func sendMoney() {
        guard let url = URL(string: "http://127.0.0.1:8080/account/transfert") else { return }


        if !recipient.isEmpty && !amount.isZero {
            transferMessage = "Successfully transferred \(amount) to \(recipient)"
        } else {
            transferMessage = "Please enter recipient and amount."
        }
    }
}

