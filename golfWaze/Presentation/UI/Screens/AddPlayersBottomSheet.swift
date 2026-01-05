//
//  AddPlayersBottomSheet.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct AddPlayersBottomSheet: View {
    
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
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Add players to play with")
                        .font(Font.customFont(.robotoMedium, .pt14))
                        .foregroundColor(.black)
                    Spacer()
                }
                Text("Who are you playing with")
                    .font(Font.customFont(.robotoBold, .pt16))
                    .foregroundColor(.black)
                    .padding(.bottom)
            }
            
            // MARK: - Your AppButton
            AppButton("Add Players", .primary) {
                print("Add Players tapped")
            }
            AppButton("Cancel", .secondary) {
                print("Next tapped")
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
    }
}

//MARK: - Preview

struct AddPlayersBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayersBottomSheet()
    }
}
