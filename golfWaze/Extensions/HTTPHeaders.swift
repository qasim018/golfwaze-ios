//
//  HTTPHeaders.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 15/12/2025.
//


import Alamofire

extension Alamofire.HTTPHeaders {
    mutating func add(_ additionalHeaders: HTTPHeaders) {
        additionalHeaders.forEach { header in
            add(header)
        }
    }
}
