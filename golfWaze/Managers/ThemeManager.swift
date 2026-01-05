//
//  ThemeManager.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import SwiftUI


final class ThemeManager {
    
    static let shared = ThemeManager()
    private init() {}
    
    var primaryColor: Color { Color(hex: "#00213D") }
    
    var backgroundColor: Color { .primary }
}
