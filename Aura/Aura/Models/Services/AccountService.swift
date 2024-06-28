//
//  AccountService.swift
//  Aura
//
//  Created by Greg on 06/06/2024.
//

import Foundation

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

class AccountService {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    func loadAccountDetails() async throws -> AccountResponse {
        
        let urlPath = "account"
        
        do {
            return try await networkService.request(urlPath: urlPath, method: .GET, body: nil)
        } catch {
            throw error
        }
    }
}
