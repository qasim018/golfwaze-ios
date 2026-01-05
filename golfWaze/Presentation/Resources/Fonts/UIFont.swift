//
//  UIFont.swift
//  golfWaze
//
//  Created by Abdullah Shahid on 20/11/2025.
//

import UIKit
import SwiftUI

extension UIFont {
    convenience init?(_ fontFamily: FontFamily, _ size: FontSize) {
        guard let fontName = fontFamily.fontName else { return nil }
        self.init(name: fontName, size: size.rawValue)
    }
}

extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
    
    static func customFont(_ fontFamily: FontFamily, _ size: FontSize) -> Font {
        guard let uiFont = UIFont(fontFamily, size) else { return .system(size: size.rawValue) }
        return Font(uiFont: uiFont)
    }
}
