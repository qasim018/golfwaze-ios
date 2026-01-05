//
//  AppResumeResponse.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 06/02/2025.
//

struct CoursesListResponse: Codable {
    let success: Bool
    let courses: [Course]
}

struct Course: Codable, Identifiable {
    
    let id: String?
    let clubName: String?
    let courseName: String?
    let location: CourseLocation?
    
    let thumbnailURL: String?
    let holesCount: Int?
    let parTotal: Int?
    let yardageTotal: Int?
    let distanceKm: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case clubName = "club_name"
        case courseName = "course_name"
        case location
        case thumbnailURL = "thumbnail_url"
        case holesCount = "holes_count"
        case parTotal = "par_total"
        case yardageTotal = "yardage_total"
        case distanceKm = "distance_km"
    }
}


struct CourseLocation: Codable {
    let latitude: Double?
    let longitude: Double?
    let address: String?
    let city: String?
    let state: String?
    let country: String?
}


