//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AppViewModel: ObservableObject {
    
    @Published var isLogged: Bool
    
    init() {
        isLogged = false
    }
    
    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel { [weak self] in
            DispatchQueue.main.async { // added main.async to be on the main thread
                self?.isLogged = true
            }
        }
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        return AccountDetailViewModel()
    }
}
