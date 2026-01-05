//
//  FontManager.swift
//  golfWaze
//
//  Created by Abdullah Shahid on 20/11/2025.
//

import UIKit

final class FontManager {
    
    static func getFontNameFromFontFile(at fontFileURL: URL)-> String? {
        let fontData: Data
        do {
            fontData = try Data(contentsOf: fontFileURL)
            if let provider = CGDataProvider.init(data: fontData as CFData) {
                
                return CGFont(provider)?.postScriptName as? NSString as? String
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func registerFont(_ fontURL: URL) -> Bool {
        
        let fontData: Data
        do {
            fontData = try Data(contentsOf: fontURL)
        } catch(let error) {
            print(error.localizedDescription)
            return false
        }
        
        if let provider = CGDataProvider.init(data: fontData as CFData), let font:CGFont = CGFont(provider) {
            
            var error: Unmanaged<CFError>?
            if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                print(error.debugDescription)
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    static func registerAllFonts() {
        FontFamily.allCases.forEach { fontFamily in
            guard let filePath = fontFamily.filePath else { return }
            if registerFont(filePath) {
//                print("Font family '\(fontFamily.fontName ?? "")' registered successfully.")
            } else {
                print("Failed to register '\(fontFamily.fontName ?? "")'.")
            }
        }
    }
    
    static func getRegisteredFontNames()-> [String] {
        var fontNames = [String]()
        for family: String in UIFont.familyNames {
            for name: String in UIFont.fontNames(forFamilyName: family) {
                fontNames.append(name)
            }
        }
        return fontNames
    }
}
