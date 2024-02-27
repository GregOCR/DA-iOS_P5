//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var message: String = ""
    
    let onLoginSucceed: (() -> Void)
    
    private var cancellables = Set<AnyCancellable>()
    private let keychainService = KeychainService()
    private let account = "userToken"
    
    init(_ callback: @escaping () -> Void) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else { return }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.message = self.username.contains("@") ? "Unauthorized Access! Please try again." : "Username must be a valid email address."
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] authResponse in
                self?.keychainService.save(token: authResponse.token, account: self?.account ?? "")
                self?.onLoginSucceed()
            })
            .store(in: &cancellables)
    }
}

struct AuthResponse: Codable {
    let token: String
}
