//
//  DashboardTabView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 10/12/2025.
//

import SwiftUI

struct DashboardTabView: View {
    
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
        TabView() {
            CoursesMapView()
                .tabItem {
                    Images.locationPinGray
                    Text("Courses")
                }
            GolfCourseScreen()
                .tabItem {
                    Images.playIcon
                    Text("Play")
                }
            CommunityScreen()
                .tabItem {
                    Images.groupIcon
                    Text("Community")
                }
            TeeTimeListView()
                .tabItem {
                    Images.calenderIcon
                    Text("Bookings")
                }
            
            ProfileScreen()
                .tabItem {
                    Images.profileIcon
                    Text("Profile")
                }
        }
    }
}
