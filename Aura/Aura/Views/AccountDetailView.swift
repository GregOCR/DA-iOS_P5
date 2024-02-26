//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    
    @ObservedObject var viewModel: AccountDetailViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            AccoundDetailHeaderView(totalAmount: viewModel.totalAmount)
            
            // Display recent transactions
            AccountDetailRecentTransactionsView(recentTransactions: viewModel.recentTransactions)
            
            // Button to see details of transactions
            AppButtonView(title: "See Transaction Details",
                          imageName: "list.bullet",
                          action: viewModel.showTransactionDetails)
            .padding([.horizontal, .bottom])
            
            Spacer()
        }
        .onTapGesture {
            self.endEditing(true)  // This will dismiss the keyboard when tapping outside
        }
    }
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel())
}

struct AccoundDetailHeaderView: View {
    
    var totalAmount: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Your Balance")
                .font(.headline)
            Text(totalAmount)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Color.accentColor)
            Image(systemName: "eurosign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(Color.accentColor)
        }
        .padding(.top)
    }
}

struct AccountDetailRecentTransactionsView: View {
    
    var recentTransactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Transactions")
                .font(.headline)
                .padding([.horizontal])
            ForEach(recentTransactions, id: \.description) { transaction in
                HStack {
                    Image(systemName: transaction.amount.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                        .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                    Text(transaction.description)
                    Spacer()
                    Text(transaction.amount)
                        .fontWeight(.bold)
                        .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding([.horizontal])
            }
        }
    }
}
