//
//  LoginScreen.swift
//  golfWaze
//
//  Created by apple on 17/12/2025.
//

//import SwiftUI
//
//struct LoginScreen: View {
//    @State private var email = ""
//    @State private var password = ""
//    
//    @EnvironmentObject var coordinator: AuthCoordinator
//
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            Image("logo")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 100, height: 100)
//                .background(Color.gray.opacity(0.2))
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .padding(.top, 60)
//            
//            Text("Login")
//                .font(.title)
//                .fontWeight(.semibold)
//                .padding(.top, 20)
//            
//            Spacer()
//                .frame(height: 40)
//            
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Email/Username")
//                    .font(.system(size: 14))
//                    .foregroundColor(.black)
//                
//                TextField("", text: $email)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .autocapitalization(.none)
//                    .keyboardType(.emailAddress)
//            }
//            .padding(.horizontal, 24)
//            
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Password")
//                    .font(.system(size: 14))
//                    .foregroundColor(.black)
//                
//                SecureField("", text: $password)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//            }
//            .padding(.horizontal, 24)
//            .padding(.top, 16)
//            
//            Spacer()
//            
//            Button(action: {
//                print("Login tapped")
//            }) {
//                Text("Log In")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 16)
//                    .background(Color(red: 0.1, green: 0.2, blue: 0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal, 24)
//            .padding(.bottom, 20)
//            
//            HStack(spacing: 4) {
//                Text("Done have an account?")
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//                
//                Button(action: {
//                    coordinator.push(.signUpScreen)
//                    print("Sign Up tapped")
//                }) {
//                    Text("Sign Up")
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.black)
//                }
//            }
//            .padding(.bottom, 30)
//        }
//        .background(Color.white)
//    }
//}

import SwiftUI

struct LoginScreen: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    @EnvironmentObject var coordinator: AuthCoordinator
    let fromSignup: Bool
    
    init(fromSignup: Bool = false) {
        self.fromSignup = fromSignup
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 60)
            
            Text("Login")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.black)
                
                TextField("", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
//                    .keyboardType(.emailAddress)
                    .disabled(isLoading)
            }
            .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.black)
                
                SecureField("", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .disabled(isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
            }
            
            Spacer()
            
            Button(action: {
                handleLogin()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                } else {
                    Text("Log In")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color(red: 0.1, green: 0.2, blue: 0.3))
            .cornerRadius(12)
            .disabled(isLoading || username.isEmpty || password.isEmpty)
            .opacity((isLoading || username.isEmpty || password.isEmpty) ? 0.6 : 1.0)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.customFont(.robotoRegular, .pt14))
                    .foregroundColor(Color(uiColor: UIColor.init(hex: "#1A1F2F")).opacity(0.75))
                
                Button(action: {
                    if fromSignup {
                        coordinator.pop()
                    }else{
                        coordinator.push(.signUpScreen(fromLogin: true))
                    }
                    
                }) {
                    Text("Sign Up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
                .disabled(isLoading)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
    
    private func handleLogin() {
        errorMessage = ""
        isLoading = true
        
        // Device ID generate karein
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "ios_unknown"
        
        APIClient.shared.login(
            username: username,
            password: password,
            deviceId: deviceId
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let response):
                    if response.success,
                       let user = response.user {

                        let session = UserSession(
                            id: user.id ?? 0,
                            name: user.name,
                            username: user.username,
                            profileImage: user.profileImage,
                            handicap: user.handicap,
                            accessToken: response.accessToken
                        )

                        SessionManager.save(session)

                        coordinator.moveToTabbar?()
                    } else {
                        errorMessage = response.message ?? "Login failed"
                    }
                    
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}


#Preview {
    LoginScreen()
}



struct LoginResponse: Codable {
    let success: Bool
    let message: String?
    let accessToken: String?
    let user: UserData?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case accessToken = "access_token"
        case user
    }
    
    struct UserData: Codable {
        let id: Int?
        let name: String?
        let username: String?
        let profileImage: String?
        let handicap: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case username
            case profileImage = "profile_image"
            case handicap
        }
    }
}
