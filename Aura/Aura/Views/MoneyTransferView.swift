//
//  MoneyTransferView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct MoneyTransferView: View {
    
    @ObservedObject var viewModel = MoneyTransferViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Adding a fun header image
            MoneyTransferHeaderView()
            
            MoneyTransferFormView(recipientInfo: $viewModel.recipient,
                                  amount: $viewModel.amount)
            
            AppButtonView(title: "Send",
                          imageName: "arrow.right.circle.fill",
                          action: viewModel.sendMoney)
            .buttonStyle(PlainButtonStyle())
            
            // Message
            if !viewModel.transferMessage.isEmpty {
                Text(viewModel.transferMessage)
                    .padding(.top, 20)
                    .transition(.move(edge: .top))
            }
            Spacer()
        }
        .padding()
        .onTapGesture {
            self.endEditing(true)  // This will dismiss the keyboard when tapping outside
        }
    }
}

#Preview {
    MoneyTransferView()
}

struct MoneyTransferHeaderView: View {
    
    @State private var animationScale: CGFloat = 1.0
    
    var body: some View {
        
        Image(systemName: "arrow.right.arrow.left.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundColor(Color.accentColor)
            .padding()
            .scaleEffect(animationScale)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    animationScale = 1.2
                }
            }
        Text("Send Money!")
            .font(.largeTitle)
            .fontWeight(.heavy)
    }
}

struct MoneyTransferFormView: View {
    
    @Binding var recipientInfo: String
    @Binding var amount: String
    
    var body: some View {
        
        MoneyTransferFormItem(title: "Recipient (Email or Phone)",
                              placeholder: "Enter recipient's info",
                              bindingText: $recipientInfo)
        
        MoneyTransferFormItem(title: "Amount (€)",
                              placeholder: "0.00",
                              bindingText: $amount)
    }
}

struct MoneyTransferFormItem: View {
    
    var title: String
    var placeholder: String
    
    @Binding var bindingText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: $bindingText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.decimalPad)
        } 
    }
}
