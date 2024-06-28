//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

enum TransferMessage: String {
    
    case none = "",
         emptyEmailAmountError = "Please input an email and an amount in respective text fields.",
         emptyEmailError = "Please input an email address.",
         emptyAmountError = "Please input an amount.",
         invalidFormattedEmailError = "Please input a valid formated email address.",
         invalidFormattedEmailAndEmptyAmountError = "Please input a valid formated email address and an amount.",
         notEnoughMoneyResourcesError = "Your current resources are insufficient. Enter a consistent amount.",
         transferError = "Transfer failed.",
         transferSuccess = "SUCCESSFULLY TRANSFERED"
}

class MoneyTransferViewModel: ObservableObject {
    
    @ObservedObject private var accountViewModel = AccountDetailViewModel()
    
    @Published var recipient: String = ""
    @Published var amount: String = ""
    
    @Published var transferMessage: TransferMessage = .none
    
    private let transferService: TransferService
    
    init(
        accountViewModel: AccountDetailViewModel = AccountDetailViewModel(),
        recipient: String,
        amount: String,
        transferMessage: TransferMessage,
        transferService: TransferService = TransferService()
    ) {
        self.accountViewModel = accountViewModel
        self.recipient = recipient
        self.amount = amount
        self.transferMessage = transferMessage
        self.transferService = transferService
    }
    
    func initTransfer() {
        recipient = ""
        amount = ""
        transferMessage = .none
    }
    
   func sendMoney() async {

       guard hasRightInformationsToSendMoney() else {
           return
       }

        do {
            let transferResponse: TransferResponse = try await transferService.transfer(recipient: recipient, amount: NSDecimalNumber(string: amount) as Decimal)
            if transferResponse == TransferResponse(status: "OK") {
                transferMessage = .transferSuccess
            }
        } catch {
            transferMessage = .transferError
            print(error.localizedDescription)
        }
    }
    
    private func hasRightInformationsToSendMoney() -> Bool {
        
        if recipient.isEmpty && amount.isEmpty {     // check if recipient and amount are empty
            transferMessage = .emptyEmailAmountError
            return false
        }
        
        if !recipient.isEmpty && amount.isEmpty { // check if amount is missing
            if !Tools.isValidEmail(recipient) { // check if recipient is a right formatted email address
                transferMessage = .invalidFormattedEmailAndEmptyAmountError
                return false
            }
            transferMessage = .emptyAmountError
            return false
        }
        
       if recipient.isEmpty && !amount.isEmpty { // check if recipient email is right formatted while amount is not empty
            transferMessage = .emptyEmailError
            return false
        }
        
        if !Tools.isValidEmail(recipient) { // check if username is a right formatted email address
            transferMessage = .invalidFormattedEmailError
            return false
        }
        
        if !accountHasEnoughMoneyForAmountTransfer() { // check if user has enough money to make the transfer
            transferMessage = .notEnoughMoneyResourcesError
            return false
        }
        
        return true
    }
    
    private func accountHasEnoughMoneyForAmountTransfer() -> Bool {
        let totalAccountAmount = formatNumberString(accountViewModel.totalAmount)
        let transferAmount = Float(amount)
        return transferAmount! <= totalAccountAmount!
    }
    
    private func formatNumberString(_ input: String) -> Float? {
        let filteredString = input.reduce("") { result, character in
            if character == "," {
                return result + "."
            } else if character.isNumber || character == "." {
                return result + String(character)
            } else {
                return result
            }
        }
        return Float(filteredString)
    }
}
