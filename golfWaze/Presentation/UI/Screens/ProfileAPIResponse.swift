//
//  ProfileAPIResponse.swift
//  golfWaze
//
//  Created by Naveed Tahir on 16/01/2026.
//


struct ProfileAPIResponse: Codable {
    let success: Bool
    let profile: ProfileData
}

struct ProfileData: Codable {
    let basic: BasicProfile
    let stats: ProfileStats
    let courseStats: CourseStats
    let swingClubStats: SwingClubStats

    enum CodingKeys: String, CodingKey {
        case basic
        case stats
        case courseStats = "course_stats"
        case swingClubStats = "swing_club_stats"
    }
}

struct BasicProfile: Codable {
    let id: Int
    let name: String
    let username: String
    let profileImage: String?   // 👈 OPTIONAL
    let handicap: Double
    let mobile: String
    let gender: String
    let bio: String
    let country: String
    let birthdate: String

    enum CodingKeys: String, CodingKey {
        case id, name, username, handicap, mobile, gender, bio, country, birthdate
        case profileImage = "profile_image"
    }
}
struct EditProfileResponse: Codable {
    let success: Bool
    let message: String?
    let profile_image_url: String?
}

struct ProfileStats: Codable {
    let friends: Int
    let rounds: Int
    let golfBagItems: Int

    enum CodingKeys: String, CodingKey {
        case friends, rounds
        case golfBagItems = "golf_bag_items"
    }
}

struct CourseStats: Codable {
    let holesPlayed: Int
    let avgScore: Double?
    let parOrBetter: Double?

    enum CodingKeys: String, CodingKey {
        case holesPlayed = "holes_played"
        case avgScore = "avg_score"
        case parOrBetter = "par_or_better"
    }
}

struct SwingClubStats: Codable {
    let driverDistance: Double?
    let iron7Distance: Double?

    enum CodingKeys: String, CodingKey {
        case driverDistance = "driver_distance"
        case iron7Distance = "iron_7_distance"
    }
}
