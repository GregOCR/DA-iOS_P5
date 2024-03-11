//
//  AuthService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation
import Combine

struct AuthResponse: Codable {
    let token: String
}

class AuthService {
    
    func login(username: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else {
            fatalError("Bad URL")
        }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            fatalError("Error while data serialization")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
