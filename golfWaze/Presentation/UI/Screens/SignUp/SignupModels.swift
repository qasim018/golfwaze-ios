//
//  SignupModels.swift
//  golfWaze
//
//  Created by Naveed Tahir on 05/01/2026.
//


struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let username: String
    let password: String
    let device_id: String
    let platform: String = "ios"
}

struct SignUpResponse: Decodable {
    let success: Bool
    let message: String?
    let access_token: String?
    let user: UserInfo?
}

struct UserInfo: Decodable {
    let id: Int?
    let name: String?
    let username: String?
    let profile_image: String?
    let handicap: Int?
}
