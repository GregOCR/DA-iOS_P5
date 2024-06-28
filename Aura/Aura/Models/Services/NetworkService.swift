//
//  NetworkService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum NetworkError: Error {
    case badUrl
    case dataSerializationError
    case accessDenied
    case invalidResponse
    case decodingError
    case serverError(Int)
    case emptyResponse
    case unknownError
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let keychainService = KeychainService()
    
    func request<T: Decodable>(urlPath: String, method: HTTPMethod = .GET, body: [String: Any]? = nil) async throws -> T {
                
        let stringRequest = "http://127.0.0.1:8080/\(urlPath)"

        guard let url = URL(string: stringRequest) else {
            throw NetworkError.badUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw NetworkError.dataSerializationError
            }
        }
        
        if let token = keychainService.getToken(account: "aura") {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        
        let headers = ["Content-Type": "application/json"]
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            guard !data.isEmpty else {
                throw NetworkError.emptyResponse
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        case 403:
            throw NetworkError.accessDenied
        case 400...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknownError
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(urlPath: String, method: HTTPMethod, body: [String: Any]?) async throws -> T
}
