//
//  LoginView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
        
    var body: some View {
        BottomSheetView {
            VStack(spacing: 16) {
                Text("Golf Waze")
                    .font(Font.customFont(.robotoBold, .pt24))
                    .foregroundColor(Color(hex: "#1A1F2F"))
                    .padding(.top, 4)
                    .padding(.bottom, 36)
                // Primary Get Started button
                Button(action: {
                    coordinator.moveToTabbar?()
                }) {
                    Text("Continue with Google")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundColor(Color(hex: "#F5F7F9"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(ThemeManager.shared.primaryColor)
                        .cornerRadius(12)
                }
                
                Text("or")
                // Secondary Log in button
                AppButton("Continue with Phone or Email", .secondary) {
                    // TODO: action
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
            
        }
//        topContent: {
//            VStack {
//                Spacer().frame(height: 130)
//                ZStack {
//                    RoundedRectangle(cornerRadius: 22, style: .continuous)
//                        .fill(Color.white.opacity(0.9))
//                        .frame(width: 110, height: 110)
//                    Images.logo
//                        .frame(width: 110, height: 110)
//                }
//                .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 6)
//            }
//        }
        background: {
            Images.initialScreenBg.resizable()
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}
