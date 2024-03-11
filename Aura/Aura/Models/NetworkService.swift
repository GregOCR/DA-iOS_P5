//
//  NetworkService.swift
//  Aura
//
//  Created by Greg on 27/02/2024.
//

import Foundation
import Combine

class NetworkService {
    
    static let shared = NetworkService()
    
    private let keychainService = KeychainService()

    func request<T: Decodable>(url: URL, method: String = "GET", headers: [String: String]? = nil, body: Data? = nil) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = keychainService.getToken(account: "aura") {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
