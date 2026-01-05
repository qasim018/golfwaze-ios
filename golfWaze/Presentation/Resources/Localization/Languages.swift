//
//  Languages.swift
//  golfWaze
//
//  Created by Abdullah Shahid on 20/11/2025.
//

enum Language: String, CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "العربية"
        }
    }
}
