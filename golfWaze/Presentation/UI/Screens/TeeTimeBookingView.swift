//
//  TeeTimeBookingView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 23/11/2025.
//

import SwiftUI

struct TeeTimeBookingView: View {
    
    @State private var selectedGolfers: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Header Title
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        Text("Tee time")
                            .font(Font.customFont(.robotoSemiBold, .pt16))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: Course Info
                    courseInfo
                        .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // MARK: Date & Time
                    dateTimeRow
                        .padding(.horizontal)
                    
                    // MARK: Golfers Selector
                    golfersSelector
                        .padding(.horizontal)
                    
                    // MARK: Price Summary
                    priceSummary
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            
            // MARK: Bottom Bar
            bottomBar
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: Course Info View
    private var courseInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Avon Fields Golf Course")
                .font(Font.customFont(.robotoSemiBold, .pt14))
                .foregroundStyle(Color(hex: "#1A1F2F"))
            
            Text("Grand Trunk road, Cantt city")
                .font(Font.customFont(.robotoMedium, .pt14))
                .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
            
            HStack(spacing: 6) {
                Text("4.5 miles")
                Text("•")
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14))
                Text("3.6 (63)")
            }
            .font(Font.customFont(.robotoMedium, .pt12))
            .foregroundStyle(Color(hex: "#1A1F2F"))
        }
    }
    
    // MARK: Date & Time
    private var dateTimeRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Tuesday")
                    .font(Font.customFont(.robotoMedium, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
                
                Text("November 11, 2025")
                    .font(Font.customFont(.robotoMedium, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            Spacer()
            
            Text("9:00 AM")
                .font(Font.customFont(.robotoMedium, .pt14))
                .foregroundStyle(Color(hex: "#1A1F2F"))
        }
    }
    
    // MARK: Golfers Selector
    private var golfersSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Golfers")
                .font(Font.customFont(.robotoSemiBold, .pt14))
                .foregroundStyle(Color(hex: "#1A1F2F"))
            
            HStack(spacing: 0) {
                ForEach(1...4, id: \.self) { number in
                    Button(action: { selectedGolfers = number }) {
                        Text("\(number)")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                selectedGolfers == number ?
                                ThemeManager.shared.primaryColor :
                                    Color.clear
                            )
                            .foregroundColor(
                                selectedGolfers == number ? .white : ThemeManager.shared.primaryColor
                            )
                            .overlay(
                                Rectangle()
                                    .stroke(Color(hex: "#C8C8C8"))
                            )
                    }
                }
            }
            .background(Color.gray.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    // MARK: Price Summary
    private var priceSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Green fees ( \(selectedGolfers) player* $39.00 )")
                    .font(Font.customFont(.robotoRegular, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
                Spacer()
                Text("$39.00")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            HStack {
                Text("Convenience Fee")
                    .font(Font.customFont(.robotoRegular, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
                Spacer()
                Text("$2.49")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            HStack {
                Text("Estimated Taxes")
                    .font(Font.customFont(.robotoRegular, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
                Spacer()
                Text("$0.07")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            Divider()
                .padding(.vertical, 6)
            
            HStack {
                Text("Total")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                Spacer()
                Text("$41.56")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    // MARK: Bottom Bar
    private var bottomBar: some View {
        HStack {
            
            Text("Total: $41.56")
                .font(Font.customFont(.robotoSemiBold, .pt14))
                .foregroundStyle(Color(hex: "#1A1F2F"))
            
            Spacer()
            AppButton("Continue to book", .primary) {
                
            }
            .frame(width: 148)
        }
        .padding()
        .background(Color.gray.opacity(0.07))
    }
}

struct TeeTimeBookingView_Previews: PreviewProvider {
    static var previews: some View {
        TeeTimeBookingView()
    }
}
