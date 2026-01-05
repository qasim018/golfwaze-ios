//
//  ReviewsDetailScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 23/11/2025.
//
import SwiftUI

struct ReviewsScreen: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    @StateObject var viewModel = ReviewsViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ScrollView {
                VStack(spacing: 10) {
                    Spacer().frame(height: 16) // spacing below button
                    
                    overallRatingSection()
                    breakdownBars()
                    userReviews()
                }
                .padding()
            }
            
            // 🔹 Floating Top-Right Review Button
            Button {
                coordinator.push(.writeReview)
            } label: {
                Text("Review")
                    .font(.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(hex: "#00213D"))   // dark navy
                    )
                    .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
            }
            .padding(.trailing, 20)
            .padding(.top, 6)   // sits below status bar
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Review Button
    func reviewButton() -> some View {
        HStack {
            Spacer()
            AppButton("Review", .primary) {
                coordinator.push(.writeReview)
            }
            .frame(width: 94)
//            Button(action: {}) {
//                Text("Review")
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 24)
//                    .padding(.vertical, 10)
//                    .background(Color.green)
//                    .cornerRadius(12)
//            }
        }
    }
    
    
    // MARK: Overall Rating
    func overallRatingSection() -> some View {
        VStack(spacing: 8) {
            Text(String(format: "%.1f", ReviewsViewModel().overallRating))
                .font(Font.customFont(.robotoBold, .pt26))
            
            HStack(spacing: 4) {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            Text("Based on \(ReviewsViewModel().totalReviews) reviews")
                .foregroundColor(.gray)
                .font(.customFont(.robotoMedium, .pt14))
        }
    }
    
    
    // MARK: Breakdown Bars
    func breakdownBars() -> some View {
        VStack(spacing: 16) {
            ForEach(ReviewsViewModel().breakdown) { item in
                HStack {
                    Text(item.title)
                        .font(.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                        .frame(width: 75, alignment: .leading)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.yellow)
                                .frame(width: geo.size.width * item.value / 5, height: 8)
                        }
                    }
                    .frame(height: 8)
                    
                    if let suffix = item.suffix {
                        Text(suffix)
                            .font(.customFont(.robotoMedium, .pt12))
                            .foregroundStyle(Color(hex: "#1A1F2F"))
                            .frame(width: 45, alignment: .leading)
                    } else {
                        Text(String(format: "%.1f", item.value)).font(.customFont(.robotoMedium, .pt12))
                            .foregroundStyle(Color(hex: "#1A1F2F"))
                            .frame(width: 45, alignment: .leading)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    
    // MARK: User Reviews
    func userReviews() -> some View {
        VStack(spacing: 15) {
            ForEach(ReviewsViewModel().userReviews) { review in
                reviewRow(review: review)
            }
        }
    }
    
    
    // MARK: Review Row
    func reviewRow(review: UserReview) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(alignment: .top) {
                Image(review.profileImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(review.name)
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundStyle(Color(hex: "#1A1F2F"))
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", review.rating))
                            .font(Font.customFont(.robotoMedium, .pt11))
                            .foregroundStyle(Color(hex: "#1A1F2F"))
                    }
                }
                
                Spacer()
                
                Text(review.dateRange)
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
            }
            
            wrapTags(review: review)
        }
        .padding()
        .background(Color(hex: "#F5F7F9"))
        .cornerRadius(16)
    }
    
    
    // MARK: Wrap Tags
    func wrapTags(review: UserReview) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                reviewTag(title: "Value", value: String(review.value))
                reviewTag(title: "Condition", value: String(review.condition))
                reviewTag(title: "Difficulty", value: String(review.difficulty))
            }
            
            HStack {
                reviewTag(title: "Green Speed", value: String(review.greenSpeed))
                reviewTag(title: "Pace of Play", value: review.paceOfPlay)
            }
        }
    }
    
    
    // MARK: Review Tag
    func reviewTag(title: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.customFont(.robotoMedium, .pt11))
                .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
            Text(value)
                .font(.customFont(.robotoMedium, .pt11))
                .foregroundStyle(Color(hex: "#1A1F2F"))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 0.5)
    }
    
}


// MARK: Preview
struct ReviewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsScreen()
    }
}
