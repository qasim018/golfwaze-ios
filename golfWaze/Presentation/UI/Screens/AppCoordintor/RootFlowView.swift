//
//  RootFlowView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 10/12/2025.
//

import SwiftUI

struct RootFlowView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    @StateObject private var authCoordinator = AuthCoordinator()
    @StateObject private var tabBarCoordinator = TabBarCoordinator()
    
    var body: some View {
        Group {
            switch appCoordinator.state {
            case .splash:
                SplashView()
                    .transition(.opacity)
                
            case .unauthenticated:
                NavigationStack(path: $authCoordinator.path) {
                    OnboardingView()
                        .environmentObject(authCoordinator)
                        .transition(.move(edge: .trailing))
                        .navigationDestination(for: AuthCoordinator.Route.self, destination: authDestinationView)
                }
                
            case .authenticated:
                NavigationStack(path: $tabBarCoordinator.path) {
                    DashboardTabView()
                        .environmentObject(tabBarCoordinator)
                        .transition(.move(edge: .leading))
                        .navigationDestination(
                            for: TabBarCoordinator.Route.self,
                            destination: tabBarDestinationView
                        )
                }
            }
        }
        .animation(.easeInOut, value: appCoordinator.state)
        .onAppear {
            authCoordinator.moveToTabbar = {
                appCoordinator.moveToTabbar()
                
                // for testing purpose only
                
                
                
            }
        }
    }
    
    @ViewBuilder
    func authDestinationView(_ route: AuthCoordinator.Route) -> some View {
        switch route {
        case .login:
            LoginView().environmentObject(authCoordinator)
        case .loginScreen(let fromSignup):
                LoginScreen(fromSignup: fromSignup)
                    .environmentObject(authCoordinator)
        case .signUpScreen(let fromLogin):
            SignUpScreen(fromLogin: fromLogin).environmentObject(authCoordinator)
        }
    }
    
    @ViewBuilder
    func tabBarDestinationView(_ route: TabBarCoordinator.Route) -> some View {
        switch route {
        case .writeReview:
            ReviewCourseScreen().environmentObject(tabBarCoordinator)
        case .coursesList:
            CoursesListView().environmentObject(tabBarCoordinator)
        case .golfCourseDetailView(let courseID):
             GolfCourseDetailView(courseID: courseID)
                 .environmentObject(tabBarCoordinator)
        case .courseReview:
            ReviewsScreen().environmentObject(tabBarCoordinator)
        case .friendsList:
            FriendsScreen().environmentObject(tabBarCoordinator)
        case .addFriends:
            AddFriendsScreen().environmentObject(tabBarCoordinator)
        case .editProfile:
            EditProfileScreen().environmentObject(tabBarCoordinator)
        case .golfHole(let courseID, let response):
            GolfHoleScreen(courseId: courseID, response: response)
                .environmentObject(tabBarCoordinator)
        case .createRound(let courseID, let courseName):
            StartRoundView(courseID: courseID,courseName: courseName).environmentObject(tabBarCoordinator)
        }
        
    }
}
