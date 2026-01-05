//
//  TeeTimeListView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid on 23/11/2025.
//

import SwiftUI

// MARK: - DATA MODEL (struct is OK)
struct TeeTime: Identifiable {
    let id = UUID()
    let course: String
    let distance: String
    let rating: String
    let ratingCount: Int
    let timeRange: String
    let priceRange: String
    let imageName: String
}
struct TeeTimeListView: View {
    
    @State private var selectedID: UUID? = nil
    
    let items: [TeeTime] = [
        .init(course: "Avon Fields Golf Course",
              distance: "4.5 miles",
              rating: "3.6",
              ratingCount: 63,
              timeRange: "8:36am–4:04am",
              priceRange: "$23–$48",
              imageName: "golf_item_bg")
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            mainContent()
            
            FloatingMapButton {
                print("Map tapped")
            }
            .padding(.trailing, 24)
            .padding(.bottom, 32)
        }
    }
    // MARK: - COMPONENTS CONVERTED INTO FUNCTIONS
    
    func TeeTimeCard(tee: TeeTime, isSelected: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Image(tee.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .cornerRadius(12)
            
            HStack {
                Text(tee.course)
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                
                Spacer()
                
                Text(tee.timeRange)
                    .font(Font.customFont(.robotoMedium, .pt11))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            HStack(spacing: 14) {
                Text(tee.distance)
                    .font(Font.customFont(.robotoMedium, .pt11))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14))
                    Text("\(tee.rating)(\(tee.ratingCount))")
                        .font(Font.customFont(.robotoMedium, .pt11))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                }
                
                Spacer()
                
                Text(tee.priceRange)
                    .font(Font.customFont(.robotoSemiBold, .pt12))
                    .foregroundStyle(ThemeManager.shared.primaryColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        )
    }
    
    func FilterButton() -> some View {
        @State var searchText: String = "Golf Manor"
        
        return HStack(spacing: 12) {
            
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                    Text("Today")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                TextField("Search Course", text: $searchText)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
        }
    }
    
    func FloatingMapButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(ThemeManager.shared.primaryColor)
                
                Image(systemName: "map.fill")
                    .resizable()
                    .foregroundStyle(Color.white)
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .frame(width: 70, height: 70)
            .shadow(color: Color.black.opacity(0.15), radius: 6, y: 3)
        }
    }
    
    func TeeTimeNavBar() -> some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Text("Tea Time")
                .font(Font.customFont(.robotoSemiBold, .pt16))
                .foregroundStyle(Color(hex: "#1A1F2F"))
                .padding(.leading, 4)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - MAIN SCREEN (ONLY struct left)
    
    
    
    private func mainContent() -> some View {
        VStack(spacing: 0) {
            
            TeeTimeNavBar()
            
            HStack(spacing: 12) {
                FilterButton()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            if items.isEmpty {
                VStack(alignment: .center, spacing: 8) {
                    Spacer()
                    Text("No Reservations")
                        .font(Font.customFont(.robotoMedium, .pt14))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                    Text("Book a tee time and see them here")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(items) { item in
                            TeeTimeCard(
                                tee: item,
                                isSelected: selectedID == item.id
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedID = item.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
            }
            
            Spacer(minLength: 0)
        }
        .background(Color(hex: "#F5F7F9"))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TeeTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TeeTimeListView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
            
            TeeTimeListView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}


////
////  TeeTimeListView.swift
////  golfWaze
////
////  Created by Abdullah-Shahid  on 23/11/2025.
////
//
//import SwiftUI
//
//struct TeeTime: Identifiable {
//    let id = UUID()
//    let course: String
//    let distance: String
//    let rating: String
//    let ratingCount: Int
//    let timeRange: String
//    let priceRange: String
//    let imageName: String
//}
//
//struct TeeTimeCard: View {
//    let tee: TeeTime
//    let isSelected: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            
//            Image(tee.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 150)
//                .clipped()
//                .cornerRadius(12)
//            
//            HStack {
//                Text(tee.course)
//                    .font(Font.customFont(.robotoSemiBold, .pt14))
//                    .foregroundStyle(Color(hex: "#1A1F2F"))
//                
//                Spacer()
//                
//                Text(tee.timeRange)
//                    .font(Font.customFont(.robotoMedium, .pt11))
//                    .foregroundStyle(Color(hex: "#1A1F2F"))
//            }
//            
//            HStack(spacing: 14) {
//                Text(tee.distance)
//                    .font(Font.customFont(.robotoMedium, .pt11))
//                    .foregroundStyle(Color(hex: "#1A1F2F"))
//                
//                HStack(spacing: 4) {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.system(size: 14))
//                    Text("\(tee.rating)(\(tee.ratingCount))")
//                        .font(Font.customFont(.robotoMedium, .pt11))
//                        .foregroundStyle(Color(hex: "#1A1F2F"))
//                }
//                
//                Spacer()
//                
//                Text(tee.priceRange)
//                    .font(Font.customFont(.robotoSemiBold, .pt12))
//                    .foregroundStyle(ThemeManager.shared.primaryColor)
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.white)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
//                )
//        )
//    }
//}
//struct FilterButton: View {
//    @State private var searchText: String = "Golf Manor"
//
//    var body: some View {
//        HStack(spacing: 12) {
//
//            // TODAY BUTTON
//            Button(action: {}) {
//                HStack(spacing: 6) {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 16))
//                    Text("Today")
//                        .font(.system(size: 16, weight: .medium))
//                }
//                .padding(.vertical, 10)
//                .padding(.horizontal, 14)
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
//            }
//
//            // TEXTFIELD FOR GOLF MANOR
//            HStack(spacing: 6) {
//                Image(systemName: "magnifyingglass")
//                    .font(.system(size: 16))
//                    .foregroundColor(.gray)
//
//                TextField("Search Course", text: $searchText)
//                    .font(.system(size: 16))
//                    .foregroundColor(.black)
//                    .disableAutocorrection(true)
//            }
//            .padding(.vertical, 10)
//            .padding(.horizontal, 14)
//            .background(Color.white)
//            .cornerRadius(10)
//            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
//        }
//    }
//}
//
//struct FloatingMapButton: View {
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            ZStack {
//                Circle()
//                    .fill(Color(hex: "#59C58C"))
//                
//                Image(systemName: "map.fill")
//                // replace with your asset
//                    
//                    .resizable()
//                    .foregroundStyle(Color.white)
//                    .scaledToFit()
//                    .frame(width: 36, height: 36)
//            }
//            .frame(width: 70, height: 70)
//            .shadow(color: Color.black.opacity(0.15), radius: 6, y: 3)
//        }
//    }
//}
//
//
////struct FilterButton: View {
////    let icon: String
////    let title: String
////    
////    var body: some View {
////        HStack(spacing: 6) {
////            Image(systemName: icon)
////                .font(.system(size: 16))
////                .foregroundStyle(Color(hex: "#8390AC"))
////            Text(title)
////                .font(Font.customFont(.robotoMedium, .pt14))
////                .foregroundStyle(Color(hex: "#8390AC"))
////        }
////        .padding(.vertical, 10)
////        .padding(.horizontal, 14)
////        .background(Color.white)
////        .cornerRadius(10)
////        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
////    }
////}
//struct TeeTimeNavBar: View {
//    var body: some View {
//        HStack {
//            Button(action: {}) {
//                Image(systemName: "xmark")
//                    .font(.system(size: 20, weight: .medium))
//                    .foregroundColor(.black)
//            }
//            
//            Text("Tea Time")
//                .font(Font.customFont(.robotoSemiBold, .pt16))
//                .foregroundStyle(Color(hex: "#1A1F2F"))
//                .padding(.leading, 4)
//            
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.top, 8)
//    }
//}
//
//struct TeeTimeListView: View {
//    
//    @State private var selectedID: UUID? = nil
//    
//    // Example data
////    let items: [TeeTime] = []
//    let items: [TeeTime] = [
//        .init(course: "Avon Fields Golf Course",
//              distance: "4.5 miles",
//              rating: "3.6",
//              ratingCount: 63,
//              timeRange: "8:36am–4:04am",
//              priceRange: "$23–$48",
//              imageName: "golf_item_bg"),
//        
//    ]
//    
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
//            
//            // --- Your entire current screen ---
//            mainContent()
//            
//            // --- Floating Map Button ---
//            FloatingMapButton {
//                print("Map tapped")
//            }
//            .padding(.trailing, 24)
//            .padding(.bottom, 32)
//        }
////        .ignoresSafeArea()
//    }
////    private var mainContent: some View {
////            VStack(spacing: 0) {
////                TeeTimeNavBar()
////                TeeTimeFilters()
////                    .padding(.horizontal)
////                    .padding(.top, 8)
////
////                ScrollView {
////                    VStack(spacing: 16) {
////                        // Your TeeTimeCard list…
////                    }
////                    .padding(.horizontal)
////                    .padding(.top, 12)
////                }
////                Spacer(minLength: 0)
////            }
////            .background(Color(hex: "#F5F7F9"))
////        }
//    
//    private func mainContent() -> some View {
//        VStack(spacing: 0) {
//            
//            // Navigation
//            TeeTimeNavBar()
//            
//            // Filters
//            HStack(spacing: 12) {
//                FilterButton()
//            }
//            .padding(.horizontal)
//            .padding(.top, 8)
//            
//            if items.isEmpty {
//                VStack(alignment: .center, spacing: 8) {
//                    Spacer()
//                    Text("No Reservations")
//                        .font(Font.customFont(.robotoMedium, .pt14))
//                        .foregroundStyle(Color(hex: "#1A1F2F"))
//                    Text("Book a tee time and see them here")
//                        .font(Font.customFont(.robotoMedium, .pt12))
//                        .foregroundStyle(Color(hex: "#1A1F2F"))
//                    Spacer()
//                }
//            } else {
//                ScrollView {
//                    VStack(spacing: 16) {
//                        ForEach(items) { item in
//                            TeeTimeCard(
//                                tee: item,
//                                isSelected: selectedID == item.id
//                            )
//                            .onTapGesture {
//                                withAnimation {
//                                    selectedID = item.id
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 12)
//                }
//            }
//            Spacer(minLength: 0)
//        }
//        .background(Color(hex: "#F5F7F9"))
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//struct TeeTimeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TeeTimeListView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
//                .previewDisplayName("iPhone 15 Pro Max")
//            TeeTimeListView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//                .previewDisplayName("iPhone SE (3rd generation)")
//            
//        }
//    }
//}
