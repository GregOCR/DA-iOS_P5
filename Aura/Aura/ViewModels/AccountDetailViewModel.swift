//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

struct AccountDetails {
    var currentBalance: Decimal
    var transactions: [Transaction]
}

enum AccountDetailError {
    case noError,
         loadingAccountDetailsError
}

class AccountDetailViewModel: ObservableObject {
    
    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction] = []
    
    private var networkService: NetworkServiceProtocol
    
    private var accountDetailError: AccountDetailError = .noError
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        Task {
            await loadAccountDetails()
        }
    }
    
    func loadAccountDetails() async {
        guard let url = URL(string: "http://127.0.0.1:8080/account") else { return }
        
        do {
            let accountResponse: AccountResponse = try await self.networkService.request(url: url)
            let accountDetails = transformToAccountDetails(from: accountResponse)
            await updateUI(with: accountDetails)
        } catch {
            accountDetailError = .loadingAccountDetailsError
            print("Error loading account details: \(error.localizedDescription)")
        }
    }
    
    private func transformToAccountDetails(from response: AccountResponse) -> AccountDetails {
        return AccountDetails(currentBalance: response.currentBalance,
                              transactions: response.transactions.map { transaction in
            let responseTransaction = Transaction()
            responseTransaction.value = transaction.value
            responseTransaction.label = transaction.label
            return responseTransaction
        })
    }
    
    @MainActor
    private func updateUI(with accountDetails: AccountDetails) {
        self.totalAmount = NumberFormatter.currencyFormatter.string(from: NSDecimalNumber(decimal: accountDetails.currentBalance)) ?? ""
        self.recentTransactions = accountDetails.transactions
    }
}
