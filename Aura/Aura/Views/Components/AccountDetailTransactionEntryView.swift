//
//  AccountDetailTransactionEntryView.swift
//  Aura
//
//  Created by Greg on 04/03/2024.
//

import SwiftUI

struct AccountDetailTransactionEntryView: View {
    
    var transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.value > 0 ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                .foregroundColor(transaction.value > 0 ? .green : .red)
            Text(transaction.value.description)
            Spacer()
            Text(transaction.label)
                .fontWeight(.bold)
                .foregroundColor(transaction.value > 0 ? .green : .red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding([.horizontal])    }
}

//#Preview {
//    AccountDetailTransactionEntryView()
//}
