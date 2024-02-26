//
//  Color+Extensions.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

extension Color {
    
    func translucent() -> Color {
        self.opacity(0)
    }
}
