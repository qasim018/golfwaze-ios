//
//  SessionManager.swift
//  golfWaze
//
//  Created by Naveed Tahir on 04/01/2026.
//
import Foundation

struct UserSession: Codable {
    let id: Int
    let name: String?
    let username: String?
    let profileImage: String?
    let handicap: Int?
    let accessToken: String?
}


enum SessionManager {
    
    private static let key = "user_session"
    
    static func save(_ session: UserSession) {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: key)
        }
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    static func load() -> UserSession? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(UserSession.self, from: data)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
