//
//  MockNetworkService.swift
//  AuraTests
//
//  Created by Greg on 08/06/2024.
//

import Foundation
@testable import Aura

class MockNetworkService: NetworkServiceProtocol {
    
    enum MockResponse {
        case success(Decodable)
        case failure(Error)
    }
    
    var mockResponse: MockResponse?
    
    func request<T>(urlPath: String, method: Aura.HTTPMethod, body: [String : Any]?) async throws -> T where T : Decodable {
        switch mockResponse {
        case .success(let response): return response as! T
        case .failure(let error): throw error
        case .none: throw NSError(domain:  "", code: 0, userInfo: nil)
        }
    }
}
