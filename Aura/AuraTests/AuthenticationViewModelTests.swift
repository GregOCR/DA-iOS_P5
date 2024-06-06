//
//  AuraTests.swift
//  AuraTests
//
//  Created by Greg on 12/03/2024.
//

import XCTest

import SwiftUI
import Foundation

@testable import Aura

final class AuthenticationViewModelTests: XCTestCase {
        
    let authViewModel = AuthenticationViewModel(service: FakeAuthService(), {})
    let authViewModelAccessDenied = AuthenticationViewModel(service: FakeAuthServiceAccessDenied(), {})

    func testLoginFailureDueToEmptyEmailAndPassword() async {
        authViewModel.username = ""
        authViewModel.password = ""

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .emptyUsernamePasswordError)
    }
    
    func testLoginFailureDueToEmptyPassword() async {
        authViewModel.username = "valid@email.com"
        authViewModel.password = ""

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .emptyPasswordError)
    }
    
    func testLoginFailureDueToEmptyEmail() async {
        authViewModel.username = ""
        authViewModel.password = "password123"

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .emptyUsernameError)
    }
    
    func testLoginFailureDueToInvalidFormattedEmailErrorAndEmptyPassword() async {
        authViewModel.username = "valid(AT)email.com"
        authViewModel.password = ""

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .invalidFormattedEmailAndEmptyPasswordError)
    }
    
    func testLoginFailureDueToInvalidFormattedEmailErrorAndPasswordInput() async {
        authViewModel.username = "valid(AT)email.com"
        authViewModel.password = "validPassword"

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .invalidFormattedEmailError)
    }

    func testLoginFailureDueToEmailAndPasswordError() async {
        authViewModelAccessDenied.username = "test@test.net"
        authViewModelAccessDenied.password = "321"

        await authViewModelAccessDenied.login()

        XCTAssertEqual(authViewModelAccessDenied.loginError, .accessDeniedError)
    }

    func testLoginSucceedEmail() async {
        authViewModel.username = "test@aura.app"
        authViewModel.password = "test123"

        await authViewModel.login()

        XCTAssertEqual(authViewModel.loginError, .noError)
    }
}


class FakeAuthService: AuthService {
    override func login(username: String, password: String) async throws -> AuthResponse {
      return AuthResponse(token: "1234567890")
    }
}

class FakeAuthServiceAccessDenied: AuthService {
    override func login(username: String, password: String) async throws -> AuthResponse {
        throw AuthError.accessDenied
    }
}
