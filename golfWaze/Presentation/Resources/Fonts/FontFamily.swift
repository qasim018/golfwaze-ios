//
//  FontFamily.swift
//  golfWaze
//
//  Created by Abdullah Shahid on 20/11/2025.
//

import SwiftUI

enum FontFamily: CaseIterable {
    case robotoBlack
    case robotoBlackItalic
    case robotoBold
    case robotoBoldItalic
    case robotoExtraBold
    case robotoExtraBoldItalic
    case robotoExtraLight
    case robotoExtraLightItalic
    case robotoItalic
    case robotoLight
    case robotoLightItalic
    case robotoMedium
    case robotoMediumItalic
    case robotoRegular
    case robotoSemiBold
    case robotoSemiBoldItalic
    case robotoThin
    case robotoThinItalic
    
    var filePath: URL? {
        let fileName: String
        let fileExtension: String
        switch self {
        case .robotoBlack:
            fileName = "Roboto-Black"
            fileExtension = "ttf"
        case .robotoBlackItalic:
            fileName = "Roboto-BlackItalic"
            fileExtension = "ttf"
        case .robotoBold:
            fileName = "Roboto-Bold"
            fileExtension = "ttf"
        case .robotoBoldItalic:
            fileName = "Roboto-BoldItalic"
            fileExtension = "ttf"
        case .robotoExtraBold:
            fileName = "Roboto-ExtraBold"
            fileExtension = "ttf"
        case .robotoExtraBoldItalic:
            fileName = "Roboto-ExtraBoldItalic"
            fileExtension = "ttf"
        case .robotoExtraLight:
            fileName = "Roboto-ExtraLight"
            fileExtension = "ttf"
        case .robotoExtraLightItalic:
            fileName = "Roboto-ExtraLightItalic"
            fileExtension = "ttf"
        case .robotoItalic:
            fileName = "Roboto-Italic"
            fileExtension = "ttf"
        case .robotoLight:
            fileName = "Roboto-Light"
            fileExtension = "ttf"
        case .robotoLightItalic:
            fileName = "Roboto-LightItalic"
            fileExtension = "ttf"
        case .robotoMedium:
            fileName = "Roboto-Medium"
            fileExtension = "ttf"
        case .robotoMediumItalic:
            fileName = "Roboto-MediumItalic"
            fileExtension = "ttf"
        case .robotoRegular:
            fileName = "Roboto-Regular"
            fileExtension = "ttf"
        case .robotoSemiBold:
            fileName = "Roboto-SemiBold"
            fileExtension = "ttf"
        case .robotoSemiBoldItalic:
            fileName = "Roboto-SemiBoldItalic"
            fileExtension = "ttf"
        case .robotoThin:
            fileName = "Roboto-Thin"
            fileExtension = "ttf"
        case .robotoThinItalic:
            fileName = "Roboto-ThinItalic"
            fileExtension = "ttf"
            
        }
        return Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }
    
    var fontName: String? {
        guard let filePath = filePath else { return nil }
        return FontManager.getFontNameFromFontFile(at: filePath)
    }
}
