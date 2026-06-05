//
//  NetworkClient.swift
//  golfWaze
//

import Combine
import Foundation

enum NetworkClient {

    private static let session = URLSession.shared

    static func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        APILogger.logURLRequest(request)

        do {
            let result = try await session.data(for: request)
            APILogger.logURLResponse(result.1, data: result.0, error: nil)
            return result
        } catch {
            APILogger.logURLResponse(nil, data: nil, error: error)
            throw error
        }
    }

    static func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(for: URLRequest(url: url))
    }

    @discardableResult
    static func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        APILogger.logURLRequest(request)

        return session.dataTask(with: request) { data, response, error in
            APILogger.logURLResponse(response, data: data, error: error)
            completionHandler(data, response, error)
        }
    }

    @discardableResult
    static func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        APILogger.logRequest(url: url.absoluteString, method: "GET")

        return session.dataTask(with: url) { data, response, error in
            APILogger.logURLResponse(response, data: data, error: error)
            completionHandler(data, response, error)
        }
    }

    static func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        APILogger.logURLRequest(request)

        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                APILogger.logURLResponse(output.response, data: output.data, error: nil)
            }, receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    APILogger.logURLResponse(nil, data: nil, error: error)
                }
            })
            .eraseToAnyPublisher()
    }
}
