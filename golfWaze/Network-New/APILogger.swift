//
//  APILogger.swift
//  golfWaze
//

import Foundation
import Alamofire

enum APILogger {

    static func logRequest(
        url: String,
        method: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        print("\n========== API REQUEST ==========")
        print("URL:    \(url)")
        print("Method: \(method)")

        if let parameters, !parameters.isEmpty {
            print("Params: \(parameters)")
        }

        if let headers, !headers.isEmpty {
            print("Headers: \(headers)")
        }

        if let body {
            print("Body: \(formattedBody(body))")
        }

        print("=================================\n")
    }

    static func logResponse(
        data: Data?,
        statusCode: Int? = nil,
        error: Error? = nil
    ) {
        print("\n========== API RESPONSE ==========")

        if let statusCode {
            print("Status Code: \(statusCode)")
        }

        if let error {
            print("Error: \(error.localizedDescription)")
        }

        if let data {
            print("Response: \(formattedJSON(data))")
        } else if error == nil {
            print("Response: (empty)")
        }

        print("==================================\n")
    }

    static func logURLRequest(_ request: URLRequest) {
        logRequest(
            url: request.url?.absoluteString ?? "unknown",
            method: request.httpMethod ?? "GET",
            headers: request.allHTTPHeaderFields,
            body: request.httpBody
        )
    }

    static func logURLResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        logResponse(data: data, statusCode: statusCode, error: error)
    }

    static func logAlamofireRequest(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        responseData: Data?,
        error: AFError? = nil
    ) {
        logRequest(
            url: url,
            method: method.rawValue,
            parameters: parameters,
            headers: headers.dictionary,
            body: nil
        )

        logResponse(
            data: responseData,
            error: error
        )
    }

    private static func formattedBody(_ data: Data) -> String {
        if let contentType = detectContentType(in: data),
           contentType.contains("multipart/form-data") || contentType.contains("image/") {
            return "[binary body - \(data.count) bytes]"
        }

        let json = formattedJSON(data)
        if json != data.description {
            return json
        }

        if let text = String(data: data, encoding: .utf8), text.count <= 2000 {
            return text
        }

        return "[body - \(data.count) bytes]"
    }

    private static func formattedJSON(_ data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }

        return String(data: data, encoding: .utf8) ?? data.description
    }

    private static func detectContentType(in data: Data) -> String? {
        guard let text = String(data: data.prefix(512), encoding: .utf8) else { return nil }
        if text.contains("Content-Type: image/") || text.contains("multipart/form-data") {
            return "multipart/form-data"
        }
        return nil
    }
}
