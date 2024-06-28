//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    
    @ObservedObject var viewModel: AccountDetailViewModel
    
    @State var recentTransactionsOnly: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            AccoundDetailHeaderView(totalAmount: viewModel.totalAmount)
            
            // Display recent transactions
            ScrollView {
                AccountDetailTransactionsView(transactions: viewModel.recentTransactions,
                                              recentTransactionsOnly: recentTransactionsOnly)
            }
            // Button to see details of transactions
            Button(action: {
                withAnimation {
                    recentTransactionsOnly.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text(recentTransactionsOnly ? "See Transaction Details" : "See Recent Transactions")
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding([.horizontal, .bottom])
            
            Spacer()
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.5))) // define the transition animation for the view
        .onTapGesture {
            self.endEditing(true) // This will dismiss the keyboard when tapping outside
        }
        .onAppear {
            recentTransactionsOnly = true
        }
    }
}

//#Preview {
//    AccountDetailView(viewModel: AccountDetailViewModel())
//}

struct AccoundDetailHeaderView: View {
    
    var totalAmount: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Your Balance")
                .font(.headline)
            Text(totalAmount)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Color.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 20)
            Image(systemName: "eurosign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(Color.accentColor)
        }
        .padding(.top)
    }
}

struct AccountDetailTransactionsView: View {
    
    var transactions: [Transaction]
    var recentTransactionsOnly: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recentTransactionsOnly ? "Recent Transactions" : "Transaction Details")
                .font(.headline)
                .padding([.horizontal])
            ForEach(transactions.prefix(recentTransactionsOnly ? 3 : 50), id: \.value) { transaction in
                AccountDetailTransactionEntryView(transaction: transaction)
            }
        }
    }
}
