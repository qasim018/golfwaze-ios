//
//  ReviewCourseScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct ReviewCourseScreen: View {

    @State private var selectedTee: String = "@(10-18)+(91-27)"
    @State private var rating: Int = 1
    @State private var reviewText: String = ""

    @EnvironmentObject var coordinator: TabBarCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: - Header
            HStack {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Text("Review this Course")
                    .font(Font.customFont(.robotoSemiBold, .pt16))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                Spacer()
            }
            .padding(.top, 8)
            
            // MARK: - Course Row
            HStack(alignment: .top, spacing: 12) {
                Image("course_image") // replace with actual asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Avon Fields Golf Course")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                    
                    Menu {
                        Button("@(10-18)+(91-27)") {
                            selectedTee = "@(10-18)+(91-27)"
                        }
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                        Button("@(11-11)+(88-22)") {
                            selectedTee = "@(11-11)+(88-22)"
                        }
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                    } label: {
                        HStack {
                            Text(selectedTee)
                                .font(Font.customFont(.robotoSemiBold, .pt16))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ThemeManager.shared.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            
            // MARK: - Rating Section
            
            
            HStack(spacing: 12) {
                Text("Ratings")
                    .font(Font.customFont(.robotoMedium, .pt14))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                Spacer()
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(index <= rating ? .yellow : .gray)
                        .onTapGesture { rating = index }
                }
            }
            
            // MARK: - Review Text Area
            TextEditor(text: $reviewText)
                .font(Font.customFont(.robotoMedium, .pt12))
                .padding()
                .frame(height: 160)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Group {
                        if reviewText.isEmpty {
                            HStack {
                                VStack {
                                    Text("Write your course review")
                                        .font(Font.customFont(.robotoSemiBold, .pt16))
                                        .foregroundStyle(Color(hex: "1A1F2F").opacity(0.7))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                        .padding()
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct ReviewCourseScreen_Previews: PreviewProvider {
    //"iPhone SE (3rd generation)", "iPhone 15 Pro Max"

    static var previews: some View {
        Group {
            ReviewCourseScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            ReviewCourseScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}
