//
//  DashboardTabView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 10/12/2025.
//

import SwiftUI

struct DashboardTabView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var coordinator: TabBarCoordinator
    @State private var showGuestRestrictionAlert = false
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Selected tab color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#00213D")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#00213D")
        ]
        
        // Unselected tab color
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#8390AC")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#8390AC")
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: tabSelection) {
            CoursesMapView()
                .tag(TabBarCoordinator.Tab.courses)
                .tabItem {
                    Images.locationPinGray
                    Text("Courses")
                }
            GolfCourseScreen(course: CourseDetail(id: "19433", clubName: "", courseName: "", location: nil, thumbnailURL: "", holesCount: 0, parTotal: 0, yardageTotal: 0, tees: []))
                .tag(TabBarCoordinator.Tab.play)
                .tabItem {
                    Images.playIcon
                    Text("Play")
                }
            CommunityScreen()
                .tag(TabBarCoordinator.Tab.community)
                .tabItem {
                    Images.groupIcon
                    Text("Community")
                }
            TeeTimeListView()
                .tag(TabBarCoordinator.Tab.teaTime)
                .tabItem {
                    Images.calenderIcon
                    Text("Tea Time")
                }
            
            ProfileScreen()
                .tag(TabBarCoordinator.Tab.profile)
                .tabItem {
                    Images.profileIcon
                    Text("Profile")
                }
        }
        .alert("Login Required", isPresented: $showGuestRestrictionAlert) {
            Button("Login") {
                openLogin()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This section is only available after logging in. Guest mode can browse courses and use the profile guest screen.")
        }
    }

    private var tabSelection: Binding<TabBarCoordinator.Tab> {
        Binding(
            get: { coordinator.selectedTab },
            set: { newValue in
                if SessionManager.isGuestSession,
                   newValue != .courses,
                   newValue != .profile {
                    showGuestRestrictionAlert = true
                    coordinator.selectedTab = .courses
                    return
                }

                coordinator.selectedTab = newValue
            }
        )
    }

    private func openLogin() {
        SessionManager.clear()
        coordinator.popToRoot()
        appCoordinator.moveToAuth()
    }
}
