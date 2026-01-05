//
//  CreateRoundRequest.swift
//  golfWaze
//
//  Created by Naveed Tahir on 04/01/2026.
//



import Foundation

// MARK: - Create Round Request
struct CreateRoundRequest: Encodable {
    let owner_player_id: String
    let course_id: String
    let round_style: String
    let start_hole: Int
    let tee_id: String
    let players: [String]
    let token: String
}


// MARK: - Create Round Response
struct CreateRoundResponse: Decodable {
    let success: Bool
    let round_id: String?
    let status: String?
    let created_at: String?
    let course: CourseInfo?
    let tee: TeeInfo?
    let players: [RoundPlayer]?
    let holes: [HoleInfo]?
    let scores: [ScoreInfo]?
}

struct CourseInfo: Decodable {
    let course_id: String
    let club_name: String
    let course_name: String
    let location: CourseLocation
    let holes_count: String
}

struct TeeInfo: Decodable {
    let tee_id: String
    let tee_name: String
}

struct RoundPlayer: Decodable {
    let player_id: String
    let name: String
    let profile_pic: String?
}

struct HoleInfo: Decodable {
    let hole_number: Int
    let par: Int
    let handicap: Int
    let yardage: Int
}

struct ScoreInfo: Decodable {}


// MARK: - Live Traffic Response
struct LiveTrafficResponse: Decodable {
    let success: Bool
    let course_id: String
    let active_players: [ActivePlayer]
    let meta: TrafficMeta
}

struct ActivePlayer: Decodable, Identifiable {
    var id: String { user_id }

    let user_id: String
    let name: String
    let profile_pic: String?
    let hole_number: Int
    let location: PlayerLocation
    let pace: PlayerPace
    let timing: PlayerTiming
    let round_id: String
    let status: String
    let updated_at: String
}

struct PlayerLocation: Decodable {
    let lat: Double
    let lng: Double
}

struct PlayerPace: Decodable {
    let current_hole_minutes: Int
    let avg_per_hole: Double
}

struct PlayerTiming: Decodable {
    let start_time: String?
    let pace_per_hole: String?
    let estimated_finish: String?
}

struct TrafficMeta: Decodable {
    let total_players: Int
    let timestamp: String
}



struct UpdateLiveTrafficRequest: Encodable {
    let course_id: String
    let hole_number: Int
    let lat: Double
    let lng: Double
    let user_id: String
    let round_id: String
    let token: String
}

struct UpdateLiveTrafficResponse: Decodable {
    let success: Bool
    let message: String
    let data: LiveTrafficPlayerUpdate
}

struct LiveTrafficPlayerUpdate: Decodable {
    let user_id: String
    let name: String
    let course_id: String
    let hole_number: Int
    let location: PlayerLocation
    let round_id: String
    let status: String
    let updated_at: String
}
