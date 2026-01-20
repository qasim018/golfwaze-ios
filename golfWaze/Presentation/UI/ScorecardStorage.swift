//
//  ScorecardStorage.swift
//  golfWaze
//
//  Created by Naveed Tahir on 20/01/2026.
//


import Foundation

struct HoleStatsModel: Codable {
    var score: Int?
    var putts: Int?
    var fairwayHit: Bool?
    var gir: Bool?
    var chipShots: Int?
    var sandShots: Int?
    var penalties: Int?
    
    init(
        score: Int? = nil,
        putts: Int? = nil,
        fairwayHit: Bool? = nil,
        gir: Bool? = nil,
        chipShots: Int? = nil,
        sandShots: Int? = nil,
        penalties: Int? = nil
    ) {
        self.score = score
        self.putts = putts
        self.fairwayHit = fairwayHit
        self.gir = gir
        self.chipShots = chipShots
        self.sandShots = sandShots
        self.penalties = penalties
    }
}


extension HoleStatsModel {
    func hasAnyValue() -> Bool {
        return score != nil ||
               putts != nil ||
               fairwayHit != nil ||
               gir != nil ||
               chipShots != nil ||
               sandShots != nil ||
               penalties != nil
    }
}


final class ScorecardStorage {
    static let shared = ScorecardStorage()
    private let key = "golf_hole_stats"

    private init() {}

    func save(hole: Int, model: HoleStatsModel) {
        var all = loadAll()
        all[hole] = model
        if let data = try? JSONEncoder().encode(all) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load(hole: Int) -> HoleStatsModel {
        let all = loadAll()
        return all[hole] ?? HoleStatsModel()
    }

    func loadAll() -> [Int: HoleStatsModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Int: HoleStatsModel].self, from: data)
        else {
            return [:]
        }
        return decoded
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
