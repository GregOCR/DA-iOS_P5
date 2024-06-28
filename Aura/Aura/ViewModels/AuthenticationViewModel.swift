//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

enum LoginMessageError: String {
    
    case noError = "",
         emptyUsernamePasswordError = "Please input an email and a password in respective text fields.",
         emptyUsernameError = "Please input an email address.",
         emptyPasswordError = "Please input a password.",
         invalidFormattedEmailError = "Please input a valid formated email address.",
         invalidFormattedEmailAndEmptyPasswordError = "Please input a valid formated email address and a password.",
         accessDeniedError = "Please login with a valid account email address / password."
}

class AuthenticationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginError: LoginMessageError = .noError
    
    let onLoginSucceed: ( () -> Void )
    
    private let authService: AuthService
    private let keychainService = KeychainService()
    
    private let accountName = "aura" // id name used to manage the account
    
    init(service: AuthService = AuthService(),
         _ callback: @escaping () -> Void) {
        self.authService = service
        self.onLoginSucceed = callback
    }
    
    @MainActor
    func login() async {
        
        guard loginAccessGranted() else {
            return
        }
        
        do {
            let authResponse = try await authService.login(username: username, password: password)
            keychainService.save(token: authResponse.token, account: "aura")
            onLoginSucceed()
        } catch {
            loginError = .accessDeniedError
            print(error.localizedDescription)
        }
    }
    
    private func loginAccessGranted() -> Bool {
        
        if username.isEmpty && password.isEmpty { // check if username and password are empty
            loginError = .emptyUsernamePasswordError
            return false
        }
        
        if !username.isEmpty && password.isEmpty { // check if password is missing
            if !Tools.isValidEmail(username) { // check if username is a right formatted email address
                loginError = .invalidFormattedEmailAndEmptyPasswordError
                return false
            }
            loginError = .emptyPasswordError
            return false
        }
        
        if username.isEmpty && !password.isEmpty { // check if username is a right formatted email address while password is not empty
            loginError = .emptyUsernameError
            return false
        }
        
        if !Tools.isValidEmail(username) { // check if username is a right formatted email address
            loginError = .invalidFormattedEmailError
            return false
        }
        
        return true
    }
}
