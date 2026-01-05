//
//  UserDefaultsManager.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import Foundation

final class UserDefaultsManager {

    enum Keys: String, CaseIterable {
        case selectedTheme = "selected_theme"
        
    }

    static let shared = UserDefaultsManager()
    private init() {}

    var selectedTheme: String? {
        get { return UserDefaults.standard.string(forKey: Keys.selectedTheme.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.selectedTheme.rawValue) }
    }
    
    func clearAll(excluding excludedKeys: [Keys] = []) {
        Keys.allCases.forEach { key in
            if !excludedKeys.contains(key) {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }

}
