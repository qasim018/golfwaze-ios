//
//  ResponseCode.swift
//  WiconnectRevamp
//
//  Created by Abdullah Shahid on 04/02/2025.
//

enum ResponseCode: Int, Codable {
    case tokenExpired = 401
    case success = 4000
    case optionalUpdate = 3014
    case forceUpdate = 3015
    case noDataFound = 4100
    case badRequest = 3002
    case updateFailed = 4301
    case internalServerError = 3000
    case failedCode = 3001
    case duplicateEntry = 3003
    case invalidInputParams = 3004
    case invalidToken = 3005
    case incorrectPassword = 4400
    case otpBlocked = 4401
    case unauthorised = 3008
    case invalidRequest  = 3007
}
