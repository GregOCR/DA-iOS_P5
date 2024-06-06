//
//  AuthService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation

enum AuthError: Error {
   case badUrl,
        dataSerializationError,
        accessDenied
}

struct AuthResponse: Codable {
    let token: String
}

class AuthService {

    func login(username: String, password: String) async throws -> AuthResponse {
        
        // url of the auth
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else {
            throw AuthError.badUrl
        }
        
        // body model I'm waiting to receive
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        // convert the body in JSON serialization
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            throw AuthError.dataSerializationError
        }
        
        // request with what the server needs to
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // await the response
        let (data, _) = try await URLSession.shared.data(for: request)
                
        // decode the JSON data into an instance of AuthResponse
        let decodedResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        return decodedResponse
    }
}
