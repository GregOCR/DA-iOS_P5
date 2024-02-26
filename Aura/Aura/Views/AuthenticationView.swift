//
//  AuthenticationView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    
    @ObservedObject var viewModel: AuthenticationViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            AuthenticationBackgroundGradientView()
            
            VStack(spacing: 20) {
                AuthenticationHeaderView()
                
                AuthenticationFormView(usernameBinding: $viewModel.username,
                                       passwordBinding: $viewModel.password)
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Connexion")
                        .frame(maxWidth: .infinity)
                } // login button
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            self.endEditing(true)  // dismiss the keyboard tapping outside
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel({
        
    }))
}

struct AuthenticationBackgroundGradientView: View {
    
    let gradientStart = Color.accentColor.opacity(0.7)
    let gradientEnd = Color.accentColor.translucent()
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]),
                       startPoint: .top,
                       endPoint: .bottomLeading)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AuthenticationHeaderView: View {
    var body: some View {
        
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
        
        Text("Welcome !")
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
}

struct AuthenticationFormView: View {
    
    @Binding var usernameBinding: String
    @Binding var passwordBinding: String
    
    var body: some View {
        TextField("Email address", text: $usernameBinding)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
        
        SecureField("Password", text: $passwordBinding)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
    }
}
