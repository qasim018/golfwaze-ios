//
//  CoursesListView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 14/12/2025.
//

import SwiftUI
import GoogleMaps
import SDWebImageSwiftUI

struct CoursesListView: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    @StateObject private var viewModel = CoursesListVM()
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                
                searchHeader
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.courses.isEmpty {
                            Text("No nearby courses found")
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        } else {
                            ForEach(viewModel.courses) { course in
                                CourseCardView(course: course)
                                    .onTapGesture {
                                        print("Tapped course ID:", course.id ?? "")
                                        coordinator.push(.golfCourseDetailView(courseID: course.id ?? ""))
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                
            }
            
            VStack {
                // Floating Map Button
                HStack {
                    Spacer()
                    mapFloatingButton
                        .padding()
                }
//                carousel
//                    .padding(.bottom, 24)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
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

private extension CoursesListView {
    
    
    var searchHeader: some View {
        HStack(spacing: 12) {
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search courses", text: $viewModel.searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            
            Button {
                print("Filter tapped")
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 48, height: 48)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
            }
        }
    }
    
    
}

private extension CoursesListView {
    
    var mapFloatingButton: some View {
        Button {
            print("Map tapped")
            coordinator.pop()
        } label: {
            Image(systemName: "map.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color(red: 0.03, green: 0.16, blue: 0.29))
                )
                .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
        }
    }
}

struct CourseCardView: View {
    
    //    let imageName: String
    
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WebImage(url: URL(string: course.thumbnailURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                
            } placeholder: {
                Image("golf_item_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(course.clubName ?? "")
                        .font(.headline)
                    
                    HStack(spacing: 6) {
//                        Text("\(course.distanceKm?.oneDecimalString() ?? "0.0") KM")
//                            .foregroundColor(.secondary)
//                        
                        Text(course.location?.address ?? "")
                        
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                        
//                        Text("3.6(63)")
//                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

#Preview {
    CoursesListView()
}


