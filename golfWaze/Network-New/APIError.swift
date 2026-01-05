//
//  APIError.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 04/02/2025.
//

import Foundation

enum APIError: Error {
    case networkError(String)
    case decodingError(String)
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message):
            return message
        case .decodingError(let message):
            return message
        case .unknownError:
            return "Strings.someThingWentWrong"//"Unknown error occurred"
        }
    }
}
