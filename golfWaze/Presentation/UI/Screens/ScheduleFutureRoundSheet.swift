//
//  ScheduleFutureRoundSheet.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct ScheduleFutureRoundSheet: View {

    @State private var selectedDate = "11/15/2025"
    @State private var selectedTime = "4:10 PM"

    var body: some View {
        BottomSheetView() {
            bottomSheetContent()
        } topContent: {
            Color.clear
        } background: {
        }
        .background(Color.black.opacity(0.7))
    }

    // MARK: - Bottom Sheet
    @ViewBuilder
    private func bottomSheetContent() -> some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Schedule a Future Round")
                        .font(Font.customFont(.robotoMedium, .pt14))
                        .foregroundColor(.black)
                    Spacer()
                    closeButton()
                }
                Text("When do you want to play?")
                    .font(Font.customFont(.robotoBold, .pt16))
                    .foregroundColor(.black)
            }

            // Date + Time Buttons
            HStack(spacing: 16) {
                lightSelectionButton(selectedDate)
                lightSelectionButton(selectedTime)
            }

            // MARK: - Your AppButton
            AppButton("Next", .primary) {
                print("Next tapped")
            }

        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Close Button
    @ViewBuilder
    private func closeButton() -> some View {
        Button(action: {}) {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))
                .padding(8)
        }
    }
    
    // MARK: - Light Button (Date / Time)
    @ViewBuilder
    private func lightSelectionButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoSemiBold, .pt14))
            .foregroundColor(Color(hex: "#1A1F2F"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(18)
            
    }
}

//MARK: - Preview

struct ScheduleFutureRoundSheet_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFutureRoundSheet()
    }
}
