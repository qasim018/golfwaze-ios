//
//  CoursesMapView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 13/12/2025.
//

import SwiftUI
import GoogleMaps

struct CoursesMapView: View {
    
    @StateObject private var viewModel = CoursesMapVM()
    @State private var searchText: String = ""
    
    @EnvironmentObject var nav: TabBarCoordinator
    
    var body: some View {
        ZStack {
            mapView
            
            VStack {
                // MARK: - Search Bar
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                Spacer()

                
//                // MARK: - Carousel
//                carousel
//                    .padding(.bottom, 24)
            }
        }
    }
    
    var listView: some View {
        List {
            cardView
        }
    }
    
    var cardView: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Image("course_image")
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .cornerRadius(12)
            
            HStack {
                Text("Avon Field Golf Course")
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                
                Spacer()
                
                Text("4.5 miles")
                    .font(Font.customFont(.robotoMedium, .pt11))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            HStack(spacing: 14) {
                Text("tee.distance")
                    .font(Font.customFont(.robotoMedium, .pt11))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14))
                    Text("\(4.5)(\(23))")
                        .font(Font.customFont(.robotoMedium, .pt11))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                }
                
                Spacer()
                
                Text("tee.priceRange")
                    .font(Font.customFont(.robotoSemiBold, .pt12))
                    .foregroundStyle(ThemeManager.shared.primaryColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                )
        )
    }
    
    var floatingButton: some View {
        Button(action: {
            nav.push(.coursesList)
        }) {
            Image(systemName: "list.bullet")
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(Color(red: 0.03, green: 0.16, blue: 0.29)) // dark navy
                )
        }
        .buttonStyle(.plain)
        
    }
    
    var mapView: some View {
        CoursesMapViewRepresentable(
            coordinates: viewModel.coordinates,
            markers: viewModel.markers,
            onMarkerTap: { course in
                nav.push(.golfCourseDetailView(courseID: course.id))
            },
            mapType: .satellite,     // 🛰 Satellite mode
            initialZoom: 19,         // 🔎 closer view
            minZoom: 5,
            maxZoom: 24
        )

        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.getNearbyCourses()
        }
    }
    
    var searchBar: some View {
        Button {
            nav.push(.coursesList)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                Text("Search Course")
                    .font(.system(size: 17))
                    .foregroundColor(.black.opacity(0.7))

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 4)
        }
        .buttonStyle(.plain)
    }
    
    var carousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<3) { _ in
                    carouselCard
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    var carouselCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            Spacer()
        }
        .padding()
        .frame(width: 280, height: 140)
        .background(
            Image("carousel_bg")
                .resizable()
                .scaledToFill()
        )
        .cornerRadius(12)
        .shadow(
            color: Color.black.opacity(0.25),
            radius: 6,
            x: 0,
            y: 2
        )
    }
}

#Preview {
    CoursesMapView()
}
