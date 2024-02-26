//
//  AppButtonView.swift
//  Aura
//
//  Created by Greg on 26/02/2024.
//

import SwiftUI

struct AppButtonView: View {
    
    var title: String
    var imageName: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                if imageName != nil {
                    Image(systemName: imageName!)
                }
                Text(title)
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
