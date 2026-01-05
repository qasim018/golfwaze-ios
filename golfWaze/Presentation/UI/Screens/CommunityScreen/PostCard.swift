//
//  PostCard.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct PostCard: View {

    @State var comment: String = ""
    @State private var isLiked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // MARK: - Header
            HStack(alignment: .top, spacing: 12) {
                Image("course_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("Eden Alley")
                        .font(Font.customFont(.robotoMedium, .pt16))

                    Text("4d   GT Golf Club")
                        .font(Font.customFont(.robotoRegular, .pt13))
                        .foregroundColor(Color(hex: "#64748B"))
                }

                Spacer()

                Text("11/15/2025")
                    .font(Font.customFont(.robotoRegular, .pt13))
                    .foregroundColor(Color(hex: "#64748B"))
            }

            // MARK: - Middle Course Card
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)

                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Islamabad Old Course")
                            .font(Font.customFont(.robotoMedium, .pt16))

                        Text("9 Holes")
                            .font(Font.customFont(.robotoRegular, .pt14))
                            .foregroundColor(Color(hex: "#94A3B8"))

                        HStack(spacing: 10) {
                            statBox(title: "Par", value: "1")
                            statBox(title: "FH", value: "-")
                            statBox(title: "GIR", value: "100%")
                        }

                        Text("THRU: 1")
                            .font(Font.customFont(.robotoMedium, .pt14))
                    }

                    Spacer()

                    VStack(spacing: 8) {
                        ZStack {
                            // Background Circle
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 70, height: 70)
                            
                            // Main text inside circle
                            VStack(spacing: 6) {
                                Text("To Par")
                                    .font(Font.customFont(.robotoRegular, .pt10))
                                    .foregroundColor(.black)
                                
                                Text("+59")
                                    .font(Font.customFont(.robotoMedium, .pt14))
                                    .foregroundColor(.black)
                            }
                            
                            // Bottom overlapping label
                            VStack {
                                Spacer()
                                
                                Text("Gross: 95")
                                    .font(Font.customFont(.robotoBold, .pt10))
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 40)
                                    .background(Color(hex: "#1A1F2F"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .offset(y: 20) // how much it overlaps
                            }
                        }
                        .frame(height: 100) // enough space for the overlap
                    }
                }
                .padding(20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))

            // MARK: - Comment Field
            HStack(spacing: 12) {
                Image("user_profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                TextField("Add a comment...", text: $comment)
                    .font(Font.customFont(.robotoRegular, .pt15))
            }

            // MARK: - Bottom Buttons
            HStack {
                HStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isLiked ? .red : Color(hex: "#0F172A"))
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isLiked.toggle()
                        }
                    }
                    Text("Like")
                        .font(Font.customFont(.robotoMedium, .pt15))
                        .foregroundColor(Color(hex: "#0F172A"))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#0F172A"))
                    Text("Comment")
                        .font(Font.customFont(.robotoMedium, .pt15))
                        .foregroundColor(Color(hex: "#0F172A"))
                }
            }
            .padding(.top, 4)

        }
        .padding(20)
        .background(Color(hex: "#F5F7F9"))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 3)
    }

    // MARK: - Stat Small Box
    @ViewBuilder
    private func statBox(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(Font.customFont(.robotoRegular, .pt13))
                .foregroundColor(Color(hex: "#475569"))

            Text(value)
                .font(Font.customFont(.robotoMedium, .pt15))
                .foregroundColor(Color(hex: "#0F172A"))
        }
        .frame(width: 70, height: 55)
        .background(Color(hex: "#F1F5F9"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PostCard_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            VStack {
                PostCard(comment: "This is a comment.")
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
            .previewDisplayName("iPhone 15 Pro Max")
            VStack {
                PostCard(comment: "This is a comment")
                Spacer()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}


//struct ScoreView: View {
//    var body: some View {
//        ZStack {
//            // Background Circle
//            Circle()
//                .fill(Color(.systemGray6))
//                .frame(width: 180, height: 180)
//
//            // Main text inside circle
//            VStack(spacing: 6) {
//                Text("To Par")
//                    .font(.title3)
//                    .foregroundColor(.black)
//
//                Text("+59")
//                    .font(.system(size: 40, weight: .bold))
//                    .foregroundColor(.black)
//            }
//
//            // Bottom overlapping label
//            VStack {
//                Spacer()
//
//                Text("Gross: 95")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 28)
//                    .background(Color(.darkGray))
//                    .clipShape(Capsule())
//                    .offset(y: 20) // how much it overlaps
//            }
//        }
//        .frame(height: 220) // enough space for the overlap
//    }
//}
