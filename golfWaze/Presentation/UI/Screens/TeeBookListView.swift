//
//  BookListView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 23/11/2025.
//

import SwiftUI

struct TeeBookListView: View {
    
    var body: some View {
        BottomSheetView(
            sheetBackgroundColor: Color(hex: "#F5F7F9")
        ) {
            mainContent()
        }
        topContent: {
            topContent()
        }
        background: {
            Images.bg_1.resizable()
        }
    }
    
    private func mainContent() -> some View {
        VStack(spacing: 12) {
            topNavigationView()
            List {
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TeeRowView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
            }
//            .listStyle(.plain)
            .listStyle(PlainListStyle())
            .frame(height: UIScreen.main.bounds.height - 350)
//            Spacer()
            
        }
//        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    
    private func TeeRowView() -> some View {
        HStack {
            
            // LEFT SECTION
            VStack(alignment: .leading, spacing: 4) {
                Text("1 to 4 Players")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("9/18 Holes")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // MIDDLE SECTION
            VStack(alignment: .leading, spacing: 4) {
                Text("$16 - $39")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ThemeManager.shared.primaryColor)
                
                Text("9:00 AM")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // RIGHT SECTION — Your reusable AppButton
            AppButton("Book", .primary, action: {
                print("Button Tapped")
            })
            .frame(width: 90) // Matches screenshot width
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
        )
    }
    
    private func topContent() -> some View {
        VStack{
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Avon Fields Golf Course")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color.white)
                    Text("Grand Trunk road, Cantt city")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(Color.white)
                    HStack() {
                        
                        Text("4.5 miles")
                            .font(Font.customFont(.robotoMedium, .pt12))
                            .foregroundStyle(Color.white)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 3, height: 3)
                            .padding(.horizontal, 10)
                        Images.ratingStar
                            .frame(width: 8, height: 8)
                        Text("3.6(63)")
                            .font(Font.customFont(.robotoMedium, .pt12))
                            .foregroundStyle(Color.white)
                    }
                }
                Spacer()
            }
            .padding(.leading, 16)
            HStack(spacing: 36) {
                VStack {
                    Text("\("18")")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color.white)
                    Text(Strings.holes)
                        .font(Font.customFont(.robotoRegular, .pt14))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Text("\("18")")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color.white)
                    Text(Strings.par)
                        .font(Font.customFont(.robotoRegular, .pt14))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Text("\("18")")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color.white)
                    Text(Strings.length)
                        .font(Font.customFont(.robotoRegular, .pt14))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Images.chevronWhiteRight
                    Text(Strings.more)
                        .font(Font.customFont(.robotoRegular, .pt14))
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .padding(.bottom, -38)
            )
            
            
            
        }
    }
    
    private func topNavigationView() -> some View {
        HStack() {
            Spacer()
            // Left Arrow
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.black.opacity(0.85))
            }
            .padding(.trailing, 32)
            
            //Spacer()
            
            // Center: Icon + Title
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                
                Text("Today")
                    .font(Font.customFont(.robotoMedium, .pt14))
            }
            .foregroundColor(Color.black.opacity(0.85))
            
            //Spacer()
            
            // Right Arrow
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.black.opacity(0.85))
            }
            .padding(.leading, 32)
            Spacer()
        }
        .padding(.horizontal, 24)
//        .padding(.vertical, 12)
//        .background(Color(hex: "#F5F7F9"))
    }
}

struct BookListView_Previews: PreviewProvider {
    //"iPhone SE (3rd generation)", "iPhone 15 Pro Max"

    static var previews: some View {
        Group {
            TeeBookListView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            TeeBookListView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}
