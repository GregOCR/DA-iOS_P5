//
//  TransfertService.swift
//  Aura
//
//  Created by Greg on 11/03/2024.
//

import Foundation

class TransferService {
    
    private let keychainService = KeychainService()
    
    func transfer(recipient: String, amount: Decimal) async throws {
        guard let url = URL(string: "http://127.0.0.1:8080/account/transfer") else {
            fatalError("Invalid URL")
        }
        
        let body: [String: Any] = [
            "recipient": recipient,
            "amount": amount
        ]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = keychainService.getToken(account: "aura") {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
            
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
