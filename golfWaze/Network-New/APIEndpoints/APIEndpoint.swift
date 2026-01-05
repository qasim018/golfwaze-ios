//
//  APIEndpoint.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 04/02/2025.
//

import Foundation
import Alamofire

//public protocol APIEndpoint {
//    associatedtype ResponseType: Decodable
//    var method: HTTPMethod { get }
//    var path: String { get }
//    var query: [URLQueryItem]? { get }
//    var body: Encodable? { get }
//    var headers: HTTPHeaders { get }
//}
//
//public extension APIEndpoint {
//    var baseURL: URL { URL(string: "some base url")! } // keep in Data layer
//    var query: [URLQueryItem]? { nil }
//    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
//
//    func asURLRequest() throws -> URLRequest {
//        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
//        components.queryItems = query
//        var req = URLRequest(url: try components.asURL())
//        req.method = method
//        headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.name) }
//        if let body {
//            req.httpBody = try JSONEncoder().encode(AnyEncodable(body))
//        }
//        return req
//    }
//}
//
//// Helper for generic Encodable bodies
//struct AnyEncodable: Encodable {
//    private let _encode: (Encoder) throws -> Void
//    init(_ encodable: Encodable) { _encode = encodable.encode }
//    func encode(to encoder: Encoder) throws { try _encode(encoder) }
//}


import Foundation
import Alamofire

protocol APIEndpoint {
    associatedtype ResponseType: Codable
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var additionalHeaders: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var cacheKey: String? { get }
    var cacheTime: Double? { get }
}

extension APIEndpoint {
    var url: String {
        return baseURL + path
    }
    
    var baseURL: String {
        return "https://golfwaze.com/"
    }
    
    var defaultHeaders: HTTPHeaders { // default headers
        return [:]
    }
    
    ///
    /// defaultHeaders + additionalHeaders
    ///
    var combinedHeaders: HTTPHeaders {
        var headers_ = defaultHeaders
        headers_.add(additionalHeaders ?? [:])
        return headers_
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var cacheKey: String? {
        return URL(string: url)?.lastPathComponent
    }
    
    var cacheTime: Double? {
        return nil
    }
}
