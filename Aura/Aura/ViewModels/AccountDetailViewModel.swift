//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import Combine
import SwiftUI

class AccountDetailViewModel: ObservableObject {
    
    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadAccountDetails()
    }
    
    func loadAccountDetails() {
        guard let url = URL(string: "http://127.0.0.1:8080/account") else { return }

        NetworkService.shared.request(url: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error loading account details: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (accountResponse: AccountResponse) in
                let accountDetails = AccountDetails(currentBalance: accountResponse.currentBalance,
                                                    transactions: accountResponse.transactions.map { transaction in
                    let responseTransaction = Transaction()
                    responseTransaction.value = transaction.value
                    responseTransaction.label = transaction.label
                    return responseTransaction
                } )
                
                self?.updateUI(with: accountDetails)
                    })
            .store(in: &cancellables)
    }
    
    private func updateUI(with accountDetails: AccountDetails) {
        DispatchQueue.main.async {
            // Mise à jour de l'interface utilisateur avec les données reçues
            self.totalAmount = NumberFormatter.currencyFormatter.string(from: NSDecimalNumber(decimal: accountDetails.currentBalance)) ?? "€0.00"
            self.recentTransactions = accountDetails.transactions
        }
    }
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        return formatter
    }()
}

struct AccountDetails {
    var currentBalance: Decimal
    var transactions: [Transaction]
}

class Transaction: ObservableObject {
    @Published var value: Decimal = 0
    @Published var label: String = ""
}
