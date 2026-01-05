//
//  String+Localization.swift
//  golfWaze
//
//  Created by Abdullah Shahid on 20/11/2025.
//

import Foundation

extension String {
    func localized(_ lang: Language? = nil)-> String {
        let language = lang ?? .english
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        
        return self // return key if translation is not available
    }
}
