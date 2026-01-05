//
//  Color.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import SwiftUI

extension Color {
    
    // Initialize Color from Hex Code (e.g. #FF5733 or 0xFF5733)
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove the '#' if it exists
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        // Ensure it's a valid 6-digit hex string
        guard hexSanitized.count == 6 else {
            self.init(red: 0, green: 0, blue: 0)
            return
        }
        
        // Convert hex string to RGB
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        if Scanner(string: hexSanitized).scanHexInt64(&rgb) {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else {
            self.init(white: 1.0, alpha: 1.0)
        }
    }
}
