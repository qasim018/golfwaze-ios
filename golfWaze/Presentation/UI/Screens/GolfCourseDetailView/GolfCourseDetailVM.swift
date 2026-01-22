//
//  GolfCourseDetailVM.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 22/11/2025.
//

import Combine

//final class GolfCourseDetailVM: ObservableObject {
//    @Published var holesCount: Int = 36
//    @Published var par: Int = 36
//    @Published var length: Int = 36
//    @Published var golfCourseName: String = "Avon Fields Golf Course"
//    @Published var address: String = "Grand Trunk road, Cantt city"
//    @Published var reviewText: String = "63 Reviews"
//    @Published var valueValue: String = "3.8"
//}

import Combine
import Foundation

final class GolfCourseDetailVM: ObservableObject {

    @Published var holesCount: Int = 0
    @Published var par: Int = 0
    @Published var length: Int = 0
    @Published var golfCourseName: String = ""
    @Published var address: String = ""
    @Published var reviewText: String = ""
    @Published var valueValue: String = ""
    @Published var players: [Player] = []
    @Published var isDeleting = false
    @Published var deleteSuccess = false
    @Published var deleteError: String?
    var courseDetail: CourseDetail?
    
    private var courseID: String

    init(courseID: String) {
        self.courseID = courseID
        fetchCourseDetails()
    }

    private func fetchCourseDetails() {
        print("Tapped course ID:", courseID)
        let urlString = "https://golfwaze.com/dashbord/api.php?action=get_course&course_id=\(courseID)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }

            if let jsonString = String(data: data, encoding: .utf8) {
                    print("RAW JSON 👉\n\(jsonString)")
                }
            
            do {
                let response = try JSONDecoder().decode(GolfCourseDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    let course = response.course
                    self.courseDetail = response.course
                    self.holesCount = course?.holesCount ?? 0
                    self.par = course?.parTotal ?? 0
                    self.length = course?.yardageTotal ?? 0
                    self.golfCourseName = course?.courseName ?? ""
                    self.address = course?.location?.address ?? ""
                    self.reviewText = "\(course?.holesCount ?? 0) Reviews"
                    self.valueValue = "4.0"
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
    
    
    func deleteRound(roundId: String) {
        isDeleting = true
        deleteError = nil

        let urlString = "https://golfwaze.com/dashbord/new_api.php?action=delete_round&round_id=\(roundId)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isDeleting = false

                if let error = error {
                    self.deleteError = error.localizedDescription
                    return
                }

                self.deleteSuccess = true
            }
        }.resume()
    }


}

struct GolfCourseDetailResponse: Codable {
    let success: Bool
    let course: CourseDetail?
}

struct CourseDetail: Codable, Equatable, Hashable {
    let id: String?
    let clubName: String?
    let courseName: String?
    let location: CourseLocation?
    let thumbnailURL: String?
    let holesCount: Int?
    let parTotal: Int?
    let yardageTotal: Int?
    let tees: [TeeInfoResponse]?

    enum CodingKeys: String, CodingKey {
        case id
        case clubName = "club_name"
        case courseName = "course_name"
        case location
        case thumbnailURL = "thumbnail_url"
        case holesCount = "holes_count"
        case parTotal = "par_total"
        case yardageTotal = "yardage_total"
        case tees
    }
}

struct TeeInfoResponse: Codable, Equatable, Hashable {
    let teeName: String?
    let teeYardage: Int?
    let courseRating: Double?
    let slopeRating: Double?

    enum CodingKeys: String, CodingKey {
        case teeName = "tee_name"
        case teeYardage = "tee_yardage"
        case courseRating = "course_rating"
        case slopeRating = "slope_rating"
    }
}


struct PlayersResponse: Codable {
    let success: Bool
    let friends: [PlayerAPI]
    let otherPlayers: [PlayerAPI]
    let meta: PlayersMeta?

    enum CodingKeys: String, CodingKey {
        case success
        case friends
        case otherPlayers = "other_players"
        case meta
    }
}

struct PlayerAPI: Codable {
    let playerID: String
    let name: String
    let profilePic: String
    let lastPlayedAt: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case name
        case profilePic = "profile_pic"
        case lastPlayedAt = "last_played_at"
        case status
    }
}

struct PlayersMeta: Codable {
    let totalFriends: Int
    let totalOtherPlayers: Int

    enum CodingKeys: String, CodingKey {
        case totalFriends = "total_friends"
        case totalOtherPlayers = "total_other_players"
    }
}
