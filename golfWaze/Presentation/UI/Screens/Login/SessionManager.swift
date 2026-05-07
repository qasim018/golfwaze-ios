//
//  SessionManager.swift
//  golfWaze
//
//  Created by Naveed Tahir on 04/01/2026.
//
import Foundation
import UIKit

struct UserSession: Codable {
    let id: Int
    let name: String?
    let username: String?
    let profileImage: String?
    let handicap: Int?
    let accessToken: String?
    let isGuest: Bool

    init(
        id: Int,
        name: String?,
        username: String?,
        profileImage: String?,
        handicap: Int?,
        accessToken: String?,
        isGuest: Bool
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.profileImage = profileImage
        self.handicap = handicap
        self.accessToken = accessToken
        self.isGuest = isGuest
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case profileImage
        case handicap
        case accessToken
        case isGuest
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        handicap = try container.decodeIfPresent(Int.self, forKey: .handicap)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        isGuest = try container.decodeIfPresent(Bool.self, forKey: .isGuest) ?? false
    }
}


enum SessionManager {
    
    private static let key = "user_session"
    private static let isLoggedInKey = "isLoggedIn"
    private static let loginBlockedKey = "device_login_blocked_after_account_deletion"
    private static let blockedReasonKey = "device_login_blocked_reason"
    
    static func save(_ session: UserSession) {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: key)
        }
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
    }

    static func startGuestSession() {
        let guestSession = UserSession(
            id: 0,
            name: "Guest User",
            username: "guest",
            profileImage: nil,
            handicap: nil,
            accessToken: nil,
            isGuest: true
        )
        save(guestSession)
    }
    
    static func load() -> UserSession? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(UserSession.self, from: data)
    }

    static var hasActiveSession: Bool {
        guard let session = load() else { return false }
        return !(session.accessToken?.isEmpty ?? true)
    }

    static var hasAppAccess: Bool {
        load() != nil
    }

    static var isGuestSession: Bool {
        load()?.isGuest == true
    }

    static var currentDeviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "ios_unknown"
    }

    static var isLoginBlockedOnDevice: Bool {
        UserDefaults.standard.bool(forKey: loginBlockedKey)
    }

    static var loginBlockedMessage: String {
        UserDefaults.standard.string(forKey: blockedReasonKey)
        ?? "This device can no longer be used to log in after the account was deleted."
    }

    static func blockLoginOnCurrentDevice(
        reason: String = "This device can no longer be used to log in after the account was deleted."
    ) {
        UserDefaults.standard.set(true, forKey: loginBlockedKey)
        UserDefaults.standard.set(reason, forKey: blockedReasonKey)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
}
