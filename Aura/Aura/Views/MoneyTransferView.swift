//
//  MoneyTransferView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct MoneyTransferView: View {
    
    @ObservedObject var transferViewModel = MoneyTransferViewModel(recipient: "", amount: "", transferMessage: .noMessage)
    @ObservedObject var accountViewModel = AccountDetailViewModel()
    
    init(transferViewModel: MoneyTransferViewModel = MoneyTransferViewModel(recipient: "", amount: "", transferMessage: .noMessage), accountViewModel: AccountDetailViewModel) {
        self.transferViewModel = transferViewModel
        self.accountViewModel = accountViewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            MoneyTransferHeaderView()
            
            MoneyTransferFormView(viewModel: transferViewModel,
                                  totalAccountAmount: accountViewModel.totalAmount,
                                  recipientInfo: $transferViewModel.recipient,
                                  amount: $transferViewModel.amount)
            
            Button(action: {
                Task {
                    await transferViewModel.sendMoney()
                }
            } ) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Send")
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if transferViewModel.transferMessage != .noMessage  {
                Text(transferViewModel.transferMessage.rawValue)
                    .padding([.horizontal, .top], 20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(transferViewModel.transferMessage == .transferSuccess ? .green : .red)
                    .fontWeight(transferViewModel.transferMessage == .transferSuccess ? .heavy : .regular)
            }
            if transferViewModel.transferMessage == .transferSuccess  {
                HStack {
                    Text("€" + transferViewModel.amount)
                        .bold()
                    + Text(" to recipient ")
                    + Text(transferViewModel.recipient.lowercased())
                        .bold()
                }
                .foregroundStyle(.green)
                
                AppButtonView(title: "Clear All",
                              imageName: "xmark.circle.fill",
                              action: { transferViewModel.initTransfer()
                })
                .padding(.top, 20)

            }
            Spacer()
        }
        .padding()
        .onTapGesture {
            self.endEditing(true)
        }
    }
}

#Preview {
    MoneyTransferView(accountViewModel: AccountDetailViewModel())
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
    
    @ObservedObject var viewModel: MoneyTransferViewModel
    
    @State var totalAccountAmount: String
    @Binding var recipientInfo: String
    @Binding var amount: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Recipient (Email or Phone)")
                .font(.headline)
            TextField("Enter recipient's info", text: $recipientInfo)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .overlay(content: { // red outline if email or access error
                    if (viewModel.transferMessage == .emptyEmailAmountError) || (viewModel.transferMessage == .emptyEmailError) || (viewModel.transferMessage == .invalidFormattedEmailAndEmptyAmountError) || (viewModel.transferMessage == .invalidFormattedEmailError) || (viewModel.transferMessage == .transferError) || (viewModel.transferMessage == .transferSuccess){
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.transferMessage == .transferSuccess ? Color.green : Color.red, lineWidth: 2)
                    }
                })
       
            Text("€ Amount (max. \(totalAccountAmount)))")
                .font(.headline)
            TextField("0.00", text: $amount)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.decimalPad)
                .onChange(of: amount, {
                    processAmount()
                })
                .overlay(content: { // red outline if email or access error
                    if (viewModel.transferMessage == .emptyAmountError) || (viewModel.transferMessage == .emptyEmailAmountError) || (viewModel.transferMessage == .invalidFormattedEmailAndEmptyAmountError) || (viewModel.transferMessage == .notEnoughMoneyResourcesError) || (viewModel.transferMessage == .transferError) || (viewModel.transferMessage == .transferSuccess){
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.transferMessage == .transferSuccess ? Color.green : Color.red, lineWidth: 2)
                    }
                })
            
        }
    }
    
    private func processAmount() {
        
        // if the first input is a "0" or "." or ",", do not input the amount
        if ["0", ".", ","].contains(amount.first) {
            amount = ""
        }
        
        if amount.first == "0" {
            amount = ""
        }
        
        // filtering only numbers, "." and ","
        let filtered = amount.filter { $0.isNumber || $0 == "." || $0 == "," }
        if filtered != amount { amount = filtered }
        
        // if input "," -> convert to "."
        if amount.last == "," {
            amount = String(amount.dropLast()) + "."
        }
        // avoid more than 1 "."
        let components = filtered.split(separator: ".", omittingEmptySubsequences: false)
        
        // allow only 2 numbers after "."
        if components.count > 2 || (components.count == 2 && components.last?.count ?? 0 > 2) {
            amount = String(filtered.dropLast())
        }
    }
}


