//
//  NetworkService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let keychainService = KeychainService()
    
    func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = keychainService.getToken(account: "aura") {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}
