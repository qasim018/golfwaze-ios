////
////  NetworkCacheManager.swift
////  WiconnectRevamp
////
////  Created by Abdullah Shahid on 25/03/2025.
////
//
//import Foundation
//import Alamofire
//
//final class NetworkCacheManager {
//    static let shared = NetworkCacheManager()
//    
//    private init() {}
//    
//    ///
//    /// Returns the file URL for a given cache key.
//    ///
//    private func fileURL(for key: String) -> URL? {
//        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
//        return cachesDirectory.appendingPathComponent(key)
//    }
//    
//    ///
//    /// Saves data to the cache for the specified key.
//    ///
//    func saveCache<E: APIEndpoint>(data: E.ResponseType, for endpoint: E) -> Bool {
//        guard let cacheKey = endpoint.cacheKey else { return false }
//        guard let url = fileURL(for: cacheKey) else { return false }
//        guard let dataa = try? JSONEncoder().encode(data) else { return false }
//        guard (try? dataa.write(to: url, options: .atomic)) != nil else { return false }
//        return true
//    }
//    
//    ///
//    /// Loads cached data for the specified key.
//    ///
//    func loadCache<E: APIEndpoint>(for endpoint: E) -> E.ResponseType? {
//        guard let cacheKey = endpoint.cacheKey else { return nil }
//        guard let url = fileURL(for: cacheKey) else { return nil }
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        
//        return try? JSONDecoder().decode(E.ResponseType.self, from: data)
//    }
//    
//    ///
//    /// Clears all cached files in the caches directory
//    ///
//    func clearAllCachedData() -> Bool {
//        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return false }
//
//        do {
//            // Get all file URLs in caches directory
//            let fileURLs = try FileManager.default.contentsOfDirectory(
//                at: cachesDirectory,
//                includingPropertiesForKeys: nil,
//                options: .skipsHiddenFiles
//            )
//            
//            // Delete each file
//            for fileURL in fileURLs {
//                try FileManager.default.removeItem(at: fileURL)
//            }
//            return true
//        } catch {
//            print("Error clearing cache: \(error.localizedDescription)")
//            return false
//        }
//    }
//    
//    func clearCache(for endpoint: any APIEndpoint) -> Bool {
//        guard let cacheKey = endpoint.cacheKey else { return false }
//        guard let url = fileURL(for: cacheKey) else { return false }
//        do {
//            try FileManager.default.removeItem(at: url)
//        } catch {
//            return false
//        }
//        return true
//    }
//}
