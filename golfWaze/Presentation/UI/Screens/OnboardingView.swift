import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    
    var body: some View {
        BottomSheetView {
            VStack(spacing: 16) {
                Text("Golf Waze")
                    .font(Font.customFont(.robotoBold, .pt24))
                    .foregroundColor(Color(hex: "#1A1F2F"))
                    .padding(.top, 4)
                    .padding(.bottom, 36)

                AppButton("Get Started", .primary) {
                    let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                       
                       if isLoggedIn {
                           // User already logged in — go to Tabbar
                           coordinator.moveToTabbar?()
                       } else {
                           // Not logged in — go to Login screen
                           coordinator.push(.loginScreen(fromSignup: false))
                       }
                }
                // Secondary Log in button
//                AppButton("Log in", .secondary) {
//                    // TODO: action
//                    coordinator.push(.loginScreen)
//
//                }
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.customFont(.robotoRegular, .pt14))
                        .foregroundColor(Color(uiColor: UIColor.init(hex: "#1A1F2F")).opacity(0.75))
                    
                    Button(action: {
                        coordinator.push(.signUpScreen(fromLogin: false))
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 50)
                
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
                .previewDevice("iPhone 14 Pro")
        }
    }
}
