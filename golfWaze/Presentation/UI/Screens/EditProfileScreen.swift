//
//  EditProfileScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct EditProfileScreen: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    
    // MARK: - State variables
    @State private var firstName = "Designer"
    @State private var lastName = "Designer"
    @State private var bio = "Designer"
    @State private var gender = "Designer"
    @State private var birthYear = "Designer"
    @State private var country = "Designer"
    @State private var email = "Designer"
    @State private var mobile = "Designer"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Fixed Header (Does NOT scroll)
            HStack(spacing: 12) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                }
                Text("Edit Profile")
                    .font(Font.customFont(.robotoMedium, .pt18))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color.white)
            .zIndex(1) // keeps header above scrolling content

            Divider()

            // MARK: - Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Profile Image
                    ZStack(alignment: .bottomTrailing) {
                        Image("course_image")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())

                        Button(action: {}) {
                            ZStack {
                                Circle()
                                    .fill(ThemeManager.shared.primaryColor)
                                    .frame(width: 36, height: 36)

                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                        }
                        .offset(x: 4, y: 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                    // MARK: - Input Fields
                    Group {
                        profileField(title: "First name", text: $firstName)
                        profileField(title: "Last name", text: $lastName)
                        profileField(title: "Short Bio", text: $bio /*, height: 90*/)
                        profileField(title: "Gender", text: $gender)
                        profileField(title: "Birth Year", text: $birthYear)
                        profileField(title: "Country", text: $country)
                        profileField(title: "Email", text: $email)
                        profileField(title: "Mobile", text: $mobile)
                    }

                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Reusable Field Component
    @ViewBuilder
    func profileField(title: String, text: Binding<String>, placeholder: String = "", height: CGFloat = 50) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.customFont(.robotoSemiBold, .pt14))
                .foregroundColor(.black)

            TextField(placeholder, text: text)
                .padding()
                .frame(height: height)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .font(Font.customFont(.robotoRegular, .pt14))
        }
    }
}


struct EditProfileScreen_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            EditProfileScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            EditProfileScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}
