//
//  AuthCoordinator.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 10/12/2025.
//

import SwiftUI
import Combine

final class AuthCoordinator: ObservableObject {
   
    enum Route: Hashable {
        case login
        case loginScreen(fromSignup: Bool = false)
        case signUpScreen(fromLogin: Bool = false)
    }
    
    @Published var path = NavigationPath()
    
    var moveToTabbar: (()->())?
    
    // PUSH
    func push(_ route: Route) {
        path.append(route)
    }
    
    // POP
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    // POP TO ROOT
    func popToRoot() {
        path = NavigationPath()
    }
}
