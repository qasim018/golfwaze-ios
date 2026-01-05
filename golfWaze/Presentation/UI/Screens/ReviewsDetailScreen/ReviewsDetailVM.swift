//
//  ReviewsDetailVM.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 23/11/2025.
//

//import Combine
import SwiftUI
import Foundation

struct ReviewBreakdown: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
    let suffix: String?   // e.g. “Medium”, “Fast“ for non-numeric fields
}

struct UserReview: Identifiable {
    let id = UUID()
    let profileImage: String
    let name: String
    let rating: Double
    let dateRange: String
    
    let value: Double
    let condition: Double
    let difficulty: Double
    let greenSpeed: Double
    let paceOfPlay: String
}

final class ReviewsViewModel: ObservableObject {
    @Published var overallRating: Double = 3.6
    @Published var totalReviews: Int = 63
    
    @Published var breakdown: [ReviewBreakdown] = [
        .init(title: "Value", value: 3.8, suffix: nil),
        .init(title: "Condition", value: 3.7, suffix: nil),
        .init(title: "Difficulty", value: 3.5, suffix: nil),
        .init(title: "Green Speed", value: 3.6, suffix: "Medium"),
        .init(title: "Pace of Play", value: 3.6, suffix: "Fast")
    ]
    
    @Published var userReviews: [UserReview] = [
        .init(profileImage: "person1",
              name: "Eden Alley",
              rating: 3.6,
              dateRange: "(10-18)+(91-27)",
              value: 3.6,
              condition: 3.6,
              difficulty: 3.6,
              greenSpeed: 3.6,
              paceOfPlay: "Fast"),
        
        .init(profileImage: "person1",
              name: "Eden Alley",
              rating: 3.6,
              dateRange: "(10-18)+(91-27)",
              value: 3.6,
              condition: 3.6,
              difficulty: 3.6,
              greenSpeed: 3.6,
              paceOfPlay: "Fast")
    ]
}
