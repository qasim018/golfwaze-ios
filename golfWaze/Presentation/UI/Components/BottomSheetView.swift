//
//  BottomSheetView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import SwiftUI
   
struct BottomSheetView<T: View, U: View, V: View>: View {
    let bottomSheetContent: () -> T
    let topContent: () -> U?
    let background: () -> V?
    let sheetBackgroundColor: Color
    init(
        sheetBackgroundColor: Color = .white,
        @ViewBuilder bottomSheetContent: @escaping () -> T,
        @ViewBuilder topContent: @escaping () -> U? = { EmptyView() },
        @ViewBuilder background: @escaping () -> V? = { EmptyView() }
    ) {
        self.sheetBackgroundColor = sheetBackgroundColor
        self.bottomSheetContent = bottomSheetContent
        self.topContent = topContent
        self.background = background
    }
    
    var body: some View {
        ZStack {
            VStack {
                background()?.scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                Spacer()
            }
            
            VStack {
                topContent()
                
                Spacer()
                
                VStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(width: 48, height: 4)
                        .padding(.top, 12)
                    
                    bottomSheetContent()
                }
                .frame(maxWidth: .infinity)
                .background(
                    sheetBackgroundColor.clipShape(RoundedRectangle(cornerRadius: 30))
                )
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: -6)
            }
        }
        .ignoresSafeArea()
    }
}
