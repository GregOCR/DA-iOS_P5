//
//  AuthService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
}

class AuthService {
    
    let networkService = NetworkService.shared

    func login(username: String, password: String) async throws -> AuthResponse {
        
        let urlPath = "auth"
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        do {
            return try await networkService.request(urlPath: urlPath, method: .POST, body: body)
        } catch {
            throw error
        }
    }
}
