//
//  EnterPastRoundPopup.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct EnterPastRoundPopup: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            popupContent()
        }
    }

    // MARK: - Popup Content Function
    @ViewBuilder
    private func popupContent() -> some View {
        VStack(spacing: 28) {

            // Title
            Text("Enter Past Round")
                .font(Font.customFont(.robotoBold, .pt14))
                .foregroundColor(.black)

            // Two Buttons (Side by Side)
            HStack(spacing: 16) {
                lightOptionButton("Total Score")
                lightOptionButton("Shot by Shot")
            }

            // Cancel Button
            //darkButton("Cancel")
            AppButton("Cancel", .primary) {
                
            }

        }
        .padding(.vertical, 32)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    // MARK: - Light Option Button (Rounded)
    @ViewBuilder
    private func lightOptionButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoBold, .pt14))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .background(Color(hex: "#F3F5F8"))
            .cornerRadius(12)
    }
}

//MARK: - Preview

struct EnterPastRoundPopup_Previews: PreviewProvider {
    static var previews: some View {
        EnterPastRoundPopup()
    }
}
