//
//  AppCoordinator.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 14/12/2025.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    enum Route: Hashable {
        case splash
        case unauthenticated
        case authenticated
    }
    
    @Published var state: Route = .splash
    @Published var isAuthenticated: Bool = false
    
    init() {
        startAppFlow()
    }
    
    /// Called on app launch
    func startAppFlow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkAuthentication()
        }
    }
    
    /// Check stored token/user session
    func checkAuthentication() {
        isAuthenticated = SessionManager.hasAppAccess
        if isAuthenticated {
            state = .authenticated
        } else {
            state = .unauthenticated
        }
    }

    func moveToTabbar() {
        checkAuthentication()
    }

    func moveToAuth() {
        isAuthenticated = false
        state = .unauthenticated
    }
}
