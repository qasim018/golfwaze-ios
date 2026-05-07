//
//  DashboardTabView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 10/12/2025.
//

import SwiftUI

struct DashboardTabView: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    
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
        TabView(selection: $coordinator.selectedTab) {
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
    }
}
