//
//  Requests.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 04/02/2025.
//

import Alamofire

//extension APIClient {
//    func getNearbyCourses(completion: @escaping @Sendable (Result<GetNearbyCoursesEndPoint.ResponseType, AFError>)->()) {
//        APIClient.shared.request(endpoint: GetNearbyCoursesEndPoint()) { result in
//            completion(result)
//        }
//    }
//}
extension APIClient {
    func getNearbyCourses(
        lat: Double,
        lng: Double,
        completion: @escaping (Result<CoursesListResponse, AFError>) -> ()
    ) {
        request(endpoint: GetNearbyCoursesEndPoint(lat: lat, lng: lng)) { result in
            completion(result)
        }
    }
}

extension APIClient {
    
    func searchCourses(
        query: String,
        completion: @escaping @Sendable (Result<CoursesListResponse, AFError>) -> ()
    ) {
        let encodedQuery =
        query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let endpoint = SearchCoursesEndPoint(query: encodedQuery)
        
        APIClient.shared.request(endpoint: endpoint) { result in
            completion(result)
        }
    }
}

extension APIClient {
    func login(
        username: String,
        password: String,
        deviceId: String,
        platform: String = "ios",
        completion: @escaping (Result<LoginResponse, AFError>) -> ()
    ) {
        request(endpoint: LoginEndpoint(
            username: username,
            password: password,
            deviceId: deviceId,
            platform: platform
        )) { result in
            completion(result)
        }
    }
}
