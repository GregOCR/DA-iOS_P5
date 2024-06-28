//
//  MoneyTransfertViewModelTests.swift
//  AuraTests
//
//  Created by Greg on 27/05/2024.
//

import XCTest
@testable import Aura

class MoneyTransferViewModelTests: XCTestCase {

    var viewModel: MoneyTransferViewModel!
    var accountViewModel: AccountDetailViewModel!
    var mockNetworkService = MockNetworkService()
    
    override func setUp() {
        super.setUp()
        accountViewModel = AccountDetailViewModel()
        viewModel = MoneyTransferViewModel(accountViewModel: accountViewModel, recipient: "", amount: "", transferMessage: .none, transferService: TransferService(networkService: self.mockNetworkService))
    }
    
    override func tearDown() {
        viewModel = nil
        accountViewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testEmptyEmailAndAmount() async {
        viewModel.recipient = ""
        viewModel.amount = ""
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .emptyEmailAmountError)
    }
    
    @MainActor
    func testEmptyAmount() async {
        viewModel.recipient = "test@example.com"
        viewModel.amount = ""
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .emptyAmountError)
    }
    
    @MainActor
    func testEmptyEmail() async {
        viewModel.recipient = ""
        viewModel.amount = "100"
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .emptyEmailError)
    }
    
    @MainActor
    func testInvalidEmailFormat() async {
        viewModel.recipient = "invalid-email"
        viewModel.amount = "100"
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .invalidFormattedEmailError)
    }
    
    @MainActor
    func testInsufficientFunds() async {
        accountViewModel.totalAmount = "50"
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .notEnoughMoneyResourcesError)
    }
    
    @MainActor
    func testSuccessfulTransfer() async {
        accountViewModel.totalAmount = "200"
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        mockNetworkService.mockResponse = .success(TransferResponse(status: "OK"))
        
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .transferSuccess)
    }
}
