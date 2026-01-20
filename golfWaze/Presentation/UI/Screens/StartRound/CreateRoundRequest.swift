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
struct CreateRoundResponse: Codable {
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

struct CourseInfo: Codable {
    let course_id: String
    let club_name: String
    let course_name: String
    let location: CourseLocation
    let holes_count: Int
}

struct TeeInfo: Codable {
    let tee_id: String
    let tee_name: String
    let has_hole_locations: Bool
    let total_yardage: Int?
}

struct RoundPlayer: Codable {
    let player_id: String
    let name: String
    let profile_pic: String?
}

struct HoleInfo: Codable {
    let hole_number: Int
    let par: Int
    let handicap: Int
    let yardage: Int
    let locations: HoleLocations

    enum CodingKeys: String, CodingKey {
        case hole_number = "hole_number"
        case par
        case handicap
        case yardage
        case locations
    }
}

struct HoleLocations: Codable {
    let tee: HoleCoordinate
    let mid: HoleCoordinate
    let green: HoleCoordinate
}

struct HoleCoordinate: Codable {
    let lat: Double
    let lng: Double
}

import CoreLocation

extension HoleInfo {
    var mapCoordinates: [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(latitude: locations.tee.lat,   longitude: locations.tee.lng),
            CLLocationCoordinate2D(latitude: locations.mid.lat,   longitude: locations.mid.lng),
            CLLocationCoordinate2D(latitude: locations.green.lat, longitude: locations.green.lng)
        ]
    }
}


struct ScoreInfo: Codable {}


// MARK: - Live Traffic Response
struct LiveTrafficResponse: Codable {
    let success: Bool
    let course_id: String
    let active_players: [ActivePlayer]
    let meta: TrafficMeta
}

struct ActivePlayer: Codable, Identifiable {
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

struct PlayerLocation: Codable {
    let lat: Double
    let lng: Double
}

struct PlayerPace: Codable {
    let current_hole_minutes: Int
    let avg_per_hole: Double
}

struct PlayerTiming: Codable {
    let start_time: String?
    let pace_per_hole: String?
    let estimated_finish: String?
}

struct TrafficMeta: Codable {
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

struct UpdateLiveTrafficResponse: Codable {
    let success: Bool
    let message: String
    let data: LiveTrafficPlayerUpdate
}

struct LiveTrafficPlayerUpdate: Codable {
    let user_id: String
    let name: String
    let course_id: String
    let hole_number: Int
    let location: PlayerLocation
    let round_id: String
    let status: String
    let updated_at: String
}

