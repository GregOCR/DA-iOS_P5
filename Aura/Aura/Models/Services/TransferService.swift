//
//  TransfertService.swift
//  Aura
//
//  Created by Greg on 11/03/2024.
//

import Foundation

struct TransferResponse: Equatable, Decodable {
    let status: String
}

class TransferService {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func transfer(recipient: String, amount: Decimal) async throws -> TransferResponse {
        
        let urlPath = "account/transfer"
        
        let body: [String: Any] = [
            "recipient": recipient,
            "amount": amount
        ]

        do {
            return try await networkService.request(urlPath: urlPath, method: .POST, body: body)
        } catch {
            throw error
        }
    }
}
