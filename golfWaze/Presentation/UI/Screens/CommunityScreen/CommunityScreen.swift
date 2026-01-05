//
//  CommunityScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct CommunityScreen: View {
    
    @State private var commentText: String = ""
    @EnvironmentObject var coordinator: TabBarCoordinator
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                // MARK: - Fixed Header
                headerView()
                
                Divider()
                
                // MARK: - Scrollable List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(0..<4) { _ in
                            PostCard(comment: commentText)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 80) // Space for floating button
                }
            }
            
            // MARK: - Floating Center Button
            VStack {
                Spacer()
                Button(action: {}) {
                    Text("Post")
                        .font(Font.customFont(.robotoMedium, .pt16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 12)
                        .background(ThemeManager.shared.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            
            Image(systemName: "chevron.left")
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Text("Community")
                .font(Font.customFont(.robotoSemiBold, .pt14))
            
            Spacer()
            
            Button(action: {
                coordinator.push(.friendsList)
            }) {
                Text("Add Friend")
                    .font(Font.customFont(.robotoMedium, .pt14))
                    .foregroundColor(.white)
                    .frame(height: 38)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(ThemeManager.shared.primaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }
}

struct CommunityScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CommunityScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            CommunityScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}
