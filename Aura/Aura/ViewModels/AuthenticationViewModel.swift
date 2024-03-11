//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Combine
import Foundation

enum LoginError: String {
    
    case none = "",
         emailError = "Please login with a valid email address.",
         passwordError = "Please login with a password.",
         accessDeniedError = "Please login with a valid email address and password.",
         emailPasswordError = "Please indicate an email and a password in respective text fields."
}

class AuthenticationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginError: LoginError = .none
    
    let onLoginSucceed: ( () -> Void )
    
    private var cancellables = Set<AnyCancellable>()
    private let authService = AuthService()
    private let keychainService = KeychainService()
    
    private let accountName = "aura" // id name used to manage the token
    
    init(_ callback: @escaping () -> Void) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        
        if username.isEmpty && password.isEmpty { // check if username and password are occured
            loginError = .emailPasswordError
            return
        }
                
        guard isValidEmail(username) else { // check if username email address is valid
            loginError = .emailError
            return
        }
        
        guard !password.isEmpty else { // check if password is login with
            loginError = .passwordError
            return
        }

        authService.login(username: username, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.loginError = .accessDeniedError // if username email address / password input is not valid
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] authResponse in
                self?.keychainService.save(token: authResponse.token,
                                           account: self?.accountName ?? "aura")
                print(authResponse.token)
                self?.onLoginSucceed()
            })
            .store(in: &cancellables)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // most emails standard format
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
