//
//  APIClient.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 04/02/2025.
//

import Foundation
import Alamofire

//import os

var isConnectedToInternet:Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
}


class APIClient: @unchecked Sendable {
    
    static let shared = APIClient() // Singleton instance for global use
    
    private init() {}
    
    /// Executes a network request
    /// - Parameters:
    ///   - endpoint: APIEndpoint conforming object
    ///   - completion: Result type with Decodable response or AFError
    
    func request<E: APIEndpoint>(
        endpoint: E,
        completion: @escaping @Sendable (Result<E.ResponseType, AFError>) -> Void
    ) {
        let request = AF.request(endpoint.url,
                                 method: endpoint.method,
                                 parameters: endpoint.parameters,
                                 encoding: endpoint.encoding,
                                 headers: endpoint.combinedHeaders)
        request.validate()
        request.responseDecodable(of: E.ResponseType.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
//                if !isConnectedToInternet {
//                    NotificationCenter.default.post(name: NSNotification.Name("show_alert"), object: nil, userInfo: ["message" : Strings.messageNoInternet])
//                } else {
//                    print("Other error: \(error.localizedDescription)")
//                    NotificationCenter.default.post(name: NSNotification.Name("show_alert"), object: nil, userInfo: ["message" : error.localizedDescription])
                    completion(.failure(error))
//                }
            }
            print("\n\n*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*")
            print("*_*_*_*_*_*_*_* Request Details *_*_*_*_*_*_*_*_*_*")
            print("HTTPMethod: \(endpoint.method)")
            print("URL:        \(endpoint.url)")
            print("Params:     \(endpoint.parameters ?? [:])")
            print("Headers:    \(endpoint.combinedHeaders)")
            print("\n*_*_*_*_*_*_*_* Response Start *_*_*_*_*_*_*_*")
            self.printJSON(response.data)
            print("*_*_*_*_*_*_*_*_*_* Response End  *_*_*_*_*_*_*_*_*_*")
            
            request.cURLDescription { curl in
                print("*_*_*_*_*_*_*_*_*_* Curl Start *_*_*_*_*_*_*_*_*_*")
                print("\(curl)")
                print("*_*_*_*_*_*_*_*_*_* Curl End *_*_*_*_*_*_*_*_*_*")
                print("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n\n")
            }
            
            
        }
        
        
    }
    
    
    func downloadFile(from url: String, to destination: URL, completion: @escaping ((URL?, AFError?)->())) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destination, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, to: destination).response { response in
            if let error = response.error {
                print("Download failed with error: \(error.localizedDescription)")
                completion(nil, error)
            } else if let fileURL = response.fileURL {
                print("File downloaded to: \(fileURL)")
                completion(fileURL, nil)
            }
        }
    }
    
    private func printJSON(_ data: Data?) {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Response JSON: \n\(jsonString)")
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
    }
}

// protocol HTTPClient {
//    func request<E: APIEndpoint>(_ endpoint: E) async throws -> E.ResponseType
//}
//
//
//public final actor APIClient: HTTPClient {
//    static let shared = APIClient()
//    private let session: Session
//    private let decoder: JSONDecoder
//    private let log = Logger(subsystem: "com.motive_task.network", category: "http")
//
//    public init(session: Session = .default, decoder: JSONDecoder = .init()) {
//        self.session = session
//        self.decoder = decoder
//        decoder.dateDecodingStrategy = .iso8601 // adjust to your backend
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//    }
//
//     func request<E: APIEndpoint>(_ endpoint: E) async throws -> E.ResponseType {
//        let request = try endpoint.asURLRequest()
//        #if DEBUG
//        log.debug("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
//        #endif
//        let value = try await session
//            .request(request)
//            .validate()
//            .serializingDecodable(E.ResponseType.self, decoder: decoder)
//            .value
//        #if DEBUG
//        log.debug("✅ \(request.url?.absoluteString ?? "")")
//        #endif
//        return value
//    }
//}

//
//
//var isConnectedToInternet:Bool {
//    return NetworkReachabilityManager()?.isReachable ?? false
//}
//
//enum SSLPinningKeys {
//    static let allowedPublicKeys: [String] = [
//        "MIIBCgKCAQEA0pfX6uGa28FmlCHH2a/enXi3VLTLBDJVkkqvCT7d+VYiqb4vZ6GCvZYFsLBnsZ3h4ZX8Vg7D6Yj7ApPcPjUdOH/lWJptmJQGSuu2jL5sssMUg5NQnZpCvTQX///J0UYjzJKaBTsN6awxEYlff8R9GNXHfeqQCSy5dCyNZ18QXhxBESNVyUsV5t1C9cP4nHWLW04/6VnKHcvBUqnctXMn0wm9ZEVErsq2xpKqwX3FmoogoaSn8mNyvZzuNvXvM2CndcqJTF/mck1g20Xz9SIcJ71IEhej1wOZ6nB+H6t1o9wBKeBibMIW9mKETIATFR7JIs8bKLfTt4T0UoTr78aYFQIDAQAB"
//    ]
//}
//
//
//class APIClient: @unchecked Sendable {
//    
//    static let shared = APIClient() // Singleton instance for global use
//    /// Executes a network request
//    /// - Parameters:
//    ///   - endpoint: APIEndpoint conforming object
//    ///   - completion: Result type with Decodable response or AFError
//    
//    func request<E: APIEndpoint>(
//        endpoint: E,
//        completion: @escaping @Sendable (Result<E.ResponseType, AFError>) -> Void
//    ) {
//        let requestClosure: () -> Void = { [weak self] in
//            guard let self = self else { return }
//            self.request(endpoint: endpoint, completion: completion)
//        }
//        
//        let request = session.request(endpoint.url,
//                                      method: endpoint.method,
//                                      parameters: endpoint.parameters,
//                                      encoding: endpoint.encoding,
//                                      headers: endpoint.combinedHeaders)
//        request.validate()
//        request.responseDecodable(of: E.ResponseType.self) { response in
//            switch response.result {
//            case .success(let value):
//                completion(.success(value))
//            case .failure(let error):
//                if !isConnectedToInternet {
//                    self.lastFailedRequest = requestClosure // 👈 store it
//                    NotificationCenter.default.post(name: NSNotification.Name("show_alert"), object: nil, userInfo: ["message" : Strings.messageNoInternet])
//                } else {
//                    if checkLogEnabled() {
//                        print("Other error: \(error.localizedDescription)")
//                    }
//                    
//                    var errorMessage: String = Strings.someThingWentWrong
//                    if error.responseCode != 502 {
//                        errorMessage = error.localizedDescription
//                    }
//                    var showAlert = true
//                    if endpoint.url.contains("/get-profile-images") || endpoint.url.contains("/user-chat-history") || endpoint.url.contains("/chats-overview") {
//                        showAlert = false
//                    }
//                    if showAlert {
//                        NotificationCenter.default.post(name: NSNotification.Name("show_alert"), object: nil, userInfo: ["message" : errorMessage])
//                    }
//                    
//                    completion(.failure(error))
//                }
//            }
//            if checkLogEnabled() {
//                print("\n\n*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*")
//                print("*_*_*_*_*_*_*_* Request Details *_*_*_*_*_*_*_*_*_*")
//                print("HTTPMethod: \(endpoint.method)")
//                print("URL:        \(endpoint.url)")
//                print("Params:     \(endpoint.parameters ?? [:])")
//                print("Headers:    \(endpoint.combinedHeaders)")
//                print("\n*_*_*_*_*_*_*_* Response Start *_*_*_*_*_*_*_*")
//            }
//            if checkLogEnabled() {
//                self.printJSON(response.data)
//                print("*_*_*_*_*_*_*_*_*_* Response End  *_*_*_*_*_*_*_*_*_*")
//            }
//            
//            request.cURLDescription { curl in
//                if checkLogEnabled() {
//                    print("*_*_*_*_*_*_*_*_*_* Curl Start *_*_*_*_*_*_*_*_*_*")
//                    print("\(curl)")
//                    print("*_*_*_*_*_*_*_*_*_* Curl End *_*_*_*_*_*_*_*_*_*")
//                    print("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*\n\n")
//                }
//            }
//            
//            
//        }
//        
//        
//    }
//    
//    
//    func downloadFile(from url: String, to destination: URL, completion: @escaping ((URL?, AFError?)->())) {
//        let destination: DownloadRequest.Destination = { _, _ in
//            return (destination, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        
//        AF.download(url, to: destination).response { response in
//            if let error = response.error {
//                if checkLogEnabled() {
//                    print("Download failed with error: \(error.localizedDescription)")
//                }
//                completion(nil, error)
//            } else if let fileURL = response.fileURL {
//                if checkLogEnabled() {
//                    print("File downloaded to: \(fileURL)")
//                }
//                completion(fileURL, nil)
//            }
//        }
//    }
//    
//    private func printJSON(_ data: Data?) {
//        if let data = data {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data)
//                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
//                   let jsonString = String(data: jsonData, encoding: .utf8) {
//                    if checkLogEnabled() {
//                        print("Response JSON: \n\(jsonString)")
//                    }
//                }
//            } catch {
//                print("Failed to parse JSON: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
