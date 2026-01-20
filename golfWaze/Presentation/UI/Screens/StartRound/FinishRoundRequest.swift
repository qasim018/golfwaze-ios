//
//  FinishRoundRequest.swift
//  golfWaze
//
//  Created by Naveed Tahir on 19/01/2026.
//


struct FinishRoundRequest: Codable {
    let token: String
    let round_id: String
    let round_finished: Bool
//    let finish_time: Int
    let finish_context: FinishContext
    let total_score: TotalScore
    let scores: [ScorePayload]
}

struct FinishContext: Codable {
    let reason: String
    let user_id: Int
}

struct TotalScore: Codable {
    let player_id: String
    let total_score: Int
}

struct ScorePayload: Codable {
    let hole_number: Int
    let player_id: String
    let strokes: Int
    let putts: Int
    let fairway_hit: Bool
    let gir: Bool
    let chip_shots: Int
    let sand_shots: Int
    let penalties: Int
}

struct FinishRoundResponse: Codable {
    let success: Bool
    let message: String
    let stats: FinishRoundStats?
}


struct FinishRoundStats: Codable {
    let round_id: String
    let status: String
    let finished_at: String
    let course_par: Int
    let player_stats: [PlayerStats]
}

struct PlayerStats: Codable {
    let player_id: String
    let total_score: Int
    let score_vs_par: Int
    let stats: PlayerDetailedStats
}

struct PlayerDetailedStats: Codable {
    let holes_played: Int
    let fir: HitStats
    let gir: HitStats
    let putts: Int
    let chip_shots: Int
    let sand_shots: Int
    let penalties: Int
    let scores: [HoleScore]
}

struct HitStats: Codable {
    let hits: Int
    let attempts: Int
    let percentage: Double
}
struct HoleScore: Codable {
    let hole_number: Int
    let strokes: Int
    let putts: Int
    let fairway_hit: Bool
    let gir: Bool
    let chip_shots: Int
    let sand_shots: Int
    let penalties: Int
    let updated_at: String
}
