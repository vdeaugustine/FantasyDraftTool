//
//  All Batters.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - AllBatters

class AllBatters: Codable, Hashable, ObservableObject {
    @Published var batters: [Batter] = []
    @Published var editedBatters: [Batter] = []

    static var shared: AllBatters = .load() ?? AllBatters()

    init() {}

    static func == (lhs: AllBatters, rhs: AllBatters) -> Bool {
        lhs.batters == rhs.batters
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(batters)
    }

    static let key = "allBatters"
    enum CodingKeys: CodingKey {
        case batters
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.batters = try values.decode([Batter].self, forKey: .batters)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(batters, forKey: .batters)
    }

    static func load() -> AllBatters? {
        if let existing = UserDefaults.standard.data(forKey: "\(Self.key)") {
            do {
                let decoder = JSONDecoder()
                let prefs = try decoder.decode(AllBatters.self, from: existing)
                return prefs
            } catch {
                print(error)
            }
        }
        return nil
    }

    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: Self.key)
        } catch {
            print(error)
        }
    }
}

extension AllBatters {
    func averagePoints(for position: Position, projection: ProjectionTypes, topX: Int? = nil) -> Double {
        var batters = Batter.getPlayers(projectionType: projection, position: position)
        if let topX = topX { batters = Array(batters.prefix(topX)) }
        return batters.reduce(Double(0)) { $0 + $1.fantasyPoints(MainModel.shared.getScoringSettings()) }
    }

    static func averagePoints(forThese batters: [Batter]) -> Double {
        (batters.reduce(Double(0)) { $0 + $1.fantasyPoints(MainModel.shared.getScoringSettings()) } / Double(batters.count)).roundTo(places: 1)
    }
}

