//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Greg on 27/05/2024.
//

import XCTest
@testable import Aura

final class AccountDetailViewModelTests: XCTestCase {
    
    lazy var viewModel = AccountDetailViewModel(networkService: mockNetworkService)
    var mockNetworkService = MockNetworkService()
    
    func testLoadAccountDetailsSuccess() async throws {
        // Given
        let accountResponse = AccountResponse(currentBalance: Decimal(1000.0), transactions: [
            AccountResponse.Transaction(value: Decimal(100.0), label: "Transaction 100.0"),
            AccountResponse.Transaction(value: Decimal(50.0), label: "Transaction 50.0")
        ])
        
        mockNetworkService.mockResponse = .success(accountResponse)
        
        // When
        await viewModel.loadAccountDetails()
        
        // Then
        XCTAssertEqual(viewModel.recentTransactions.count, 2)
        XCTAssertEqual(viewModel.recentTransactions[0].label, "Transaction 100.0")
        XCTAssertEqual(viewModel.recentTransactions[1].label, "Transaction 50.0")
        XCTAssertEqual(viewModel.totalAmount, "€1 000,00")
    }
    
    func testLoadAccountDetailsFailure() async throws {
        // Given
        mockNetworkService.mockResponse = .failure(NSError(domain: "", code: 0, userInfo: nil))
        
        // When
        await viewModel.loadAccountDetails()
        
        // Then
        XCTAssertEqual(viewModel.totalAmount, "")
        XCTAssertEqual(viewModel.recentTransactions.count, 0)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    enum MockResponse {
        case success(AccountResponse)
        case failure(Error)
    }
    
    var mockResponse: MockResponse?
    
    func request<T: Decodable>(url: URL) async throws -> T {
        switch mockResponse {
        case .success(let response):
            return response as! T
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
    }
}
