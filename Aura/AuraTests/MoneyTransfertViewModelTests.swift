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
    
    override func setUp() {
        super.setUp()
        accountViewModel = AccountDetailViewModel()
        viewModel = MoneyTransferViewModel(accountViewModel: accountViewModel, recipient: "", amount: "", transferMessage: .noMessage)
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
                
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, .transferSuccess)
    }
}

class MockTransferService: TransferService {
    
    var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
        super.init()
    }
    
    override func transfer(recipient: String, amount: Decimal) async throws {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
    }
}
