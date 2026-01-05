//
//  GolfCourseScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//
import SwiftUI

struct GolfCourseScreen: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header Image with Overlay
                headerSection
                
                // MARK: - Preview / Change Buttons
                HStack(spacing: 16) {
                    whiteButton("Preview Course")
                    whiteButton("Change Course")
                }
                .padding(.horizontal)
                
                // MARK: - Start Round Block
                VStack(alignment: .leading, spacing: 16) {
                    Text("Avon Fields Golf Course")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundColor(.black)
                    
                    Button(action: {
                        
                    }) {
                        Text("Start a round")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#001F3F"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color(hex: "#F5F7F9"))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 8)
                .padding(.horizontal, 16)
                
                // MARK: - Tips / Stats / History
                HStack(spacing: 16) {
                    greyPillButton("Course Tips")
                    greyPillButton("Course Stats")
                    greyPillButton("Round History")
                }
                .padding(.horizontal, 16)
                
                // MARK: - Long Buttons
                VStack(spacing: 16) {
                    longGreyButton("Schedule Future Round")
                    longGreyButton("Add Past Round")
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(.white))
        .ignoresSafeArea(edges: .top)
    }
    
    
        
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            Image("bg_1") // Replace with real asset
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Avon Fields Golf Course")
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.white)
                
                Text("Grand Trunk road, Cantt city")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 10) {
                    Text("4.5 miles")
                        .font(Font.customFont(.robotoMedium, .pt11))
                    Circle().frame(width: 4, height: 4)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("3.6 (63)")
                            .font(Font.customFont(.robotoMedium, .pt11))
                    }
                }
                .font(Font.customFont(.robotoRegular, .pt14))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
    
    /// White rounded button
    @ViewBuilder
    private func whiteButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoSemiBold, .pt12))
            .foregroundStyle(Color(hex: "#1A1F2F"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#F5F7F9"))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    /// Small gray pill button
    @ViewBuilder
    private func greyPillButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoBold, .pt12))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#F5F7F9"))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    /// Large long gray button
    @ViewBuilder
    private func longGreyButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoBold, .pt14))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#00213D").opacity(0.15))
            .cornerRadius(12)
            .foregroundColor(Color(hex: "#001F3F"))
    }
}
struct GolfCourseScreen_Previews: PreviewProvider {
    //"iPhone SE (3rd generation)", "iPhone 15 Pro Max"

    static var previews: some View {
        Group {
            GolfCourseScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            GolfCourseScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}

struct PlayTimePopup: View {
    var onNow: () -> Void
    var onFuture: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            
            // Dimmed Background
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack {
                Spacer()   // pushes popup to bottom
                
                VStack(spacing: 18) {
                    
                    Image(systemName: "flag.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#001F3F"))
                    
                    Text("When do you want to play?")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundColor(Color(hex: "#1A1F2F"))
                        .padding(.top, 2)
                    
                    // NOW Button
                    Button(action: onNow) {
                        Text("Now")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#001F3F"))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    
                    // FUTURE Button
                    Button(action: onFuture) {
                        Text("Future")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.gray.opacity(0.12))
                            .foregroundColor(Color(hex: "#1A1F2F"))
                            .cornerRadius(14)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(
                            .rect(
                                topLeadingRadius: 22,
                                topTrailingRadius: 22
                            )
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.spring(), value: true)
    }
}
