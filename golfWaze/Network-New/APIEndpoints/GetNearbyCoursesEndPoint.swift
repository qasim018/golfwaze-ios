//
//  GetNearbyCoursesEndPoint.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 06/02/2025.
//

import Alamofire

//struct GetNearbyCoursesEndPoint: APIEndpoint {
//    typealias ResponseType = CoursesListResponse
//    
//    var path: String = "?action=get_nearby_courses&lat=33.88&lng=-116.55&radius=20"
//    var method: Alamofire.HTTPMethod = .get
//    var parameters: Parameters?
//    var additionalHeaders: HTTPHeaders?
//}
struct GetNearbyCoursesEndPoint: APIEndpoint {
    typealias ResponseType = CoursesListResponse

    let lat: Double
    let lng: Double

    var path: String {
        "dashbord/api.php?action=get_nearby_courses&lat=\(lat)&lng=\(lng)&radius=1000"
    }

    var method: Alamofire.HTTPMethod = .get
    var parameters: Parameters?
    var additionalHeaders: HTTPHeaders?
}

struct SearchCoursesEndPoint: APIEndpoint {
    typealias ResponseType = CoursesListResponse
    
    let query: String
    var path: String {
        "dashbord/api.php?action=search_courses&q=\(query)"
    }
    var method: Alamofire.HTTPMethod = .get
    var parameters: Parameters? = nil
    var additionalHeaders: HTTPHeaders? = nil
}

struct LoginEndpoint: APIEndpoint {
    typealias ResponseType = LoginResponse
    
    let username: String
    let password: String
    let deviceId: String
    let platform: String
    
    var path: String {
        "dashbord/new_api.php?action=login"
    }
    
    var method: Alamofire.HTTPMethod = .post
    
    var parameters: Parameters? {
        return [
            "username": username,
            "password": password,
            "device_id": deviceId,
            "platform": platform
        ]
    }
    
    var additionalHeaders: HTTPHeaders?
}
