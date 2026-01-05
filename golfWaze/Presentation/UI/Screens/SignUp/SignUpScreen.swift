//
//  SignUpScreen.swift
//  golfWaze
//
//  Created by apple on 17/12/2025.
//

import SwiftUI

struct SignUpScreen: View {

    @EnvironmentObject var coordinator: AuthCoordinator
    @StateObject var viewModel = SignUpViewModel()

    let fromLogin: Bool

    init(fromLogin: Bool = false) {
        self.fromLogin = fromLogin
    }

    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {

        ZStack {
            ScrollView {
                VStack(spacing: 0) {

                    // Header Icon
                    ZStack {
                        Image("splashPerson")
                        Circle()
                            .fill(.white)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "#1A1F2F"))
                            )
                            .offset(x: 28, y: 38)
                    }
                    .padding(.top, 10)

                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 20)

                    Spacer().frame(height: 30)

                    groupField("Name", text: $name)
                    groupField("Username", text: $username)
                    groupField("Email", text: $email)

                    secureField("Password", text: $password)
                    secureField("Confirm Password", text: $confirmPassword)

                    Spacer().frame(height: 30)

                    Button {
                        Task {
                            await viewModel.signUp(
                                name: name,
                                username: username,
                                email: email,
                                password: password
                            )
                        }
                    } label: {
                        Text(viewModel.isLoading ? "Please wait..." : "Sign up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#1A1F2F"))
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.bottom, 10)
                    }

                    signInFooter
                }
                .padding(.bottom, 30)
            }
        }
        .background(Color.white)
        .onChange(of: viewModel.signupCompleted) { completed in
            if completed {
                coordinator.moveToTabbar?()
            }
        }
    }

    // MARK: - Reusable Field Builders
    func groupField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.customFont(.robotoSemiBold, .pt14))
            TextField("", text: text)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    func secureField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.customFont(.robotoSemiBold, .pt14))
            SecureField("", text: text)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .autocorrectionDisabled()
                .autocapitalization(.none)

        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    var signInFooter: some View {
        HStack(spacing: 4) {
            Text("Already have an account")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#1A1F2F").opacity(0.75))

            Button {
                if fromLogin {
                    coordinator.pop()
                } else {
                    coordinator.push(.loginScreen(fromSignup: true))
                }
            } label: {
                Text("Sign In")
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.bottom, 10)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
