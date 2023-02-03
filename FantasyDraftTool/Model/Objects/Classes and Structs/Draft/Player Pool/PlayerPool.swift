//
//  PlayerPool.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/1/23.
//

import Foundation

// MARK: - PlayerPool

struct PlayerPool: Codable, Hashable, Equatable {
    // MARK: - Stored Properties

    var batters: [ParsedBatter] {
        var retArr: [ParsedBatter] = []
        for position in Position.batters {
            if let battersAtPosition = battersDict[position] {
                retArr += battersAtPosition
            }
        }
        return retArr
    }

    var battersDict: [Position: [ParsedBatter]] = {
        var retDict: [Position: [ParsedBatter]] = [:]

        for position in Position.batters {
            let battersForThisPosition = AllParsedBatters.batters(for: .steamer, at: position)
            retDict[position] = battersForThisPosition
        }

        return retDict
    }()

    func getBattersDict() -> [Position: [ParsedBatter]] {
        battersDict
    }

    func getPositionAveragesDict() -> [Position: Double] {
        positionAveragesDict
    }

    var positionAveragesDict: [Position: Double] = emptyPosAverageDict()
    
    static func emptyPosAverageDict() -> [Position: Double] {
        var retDict: [Position: Double] = [:]

        for position in Position.batters {
            let battersForThisPosition = AllParsedBatters.batters(for: .steamer, at: position)
            retDict[position] = ParsedBatter.averagePoints(forThese: battersForThisPosition)
        }

        return retDict
    }

    // MARK: - Methods

    mutating func recalculateDict() {
        for pos in battersDict.keys {
            if let posBatters = battersDict[pos] {
                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
            }
        }
    }

    mutating func recalculateDict(for positions: [Position]) {
        for pos in positions {
            if let posBatters = battersDict[pos] {
                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
            }
        }
    }

    // MARK: - Initializers

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.battersDict = try container.decode([Position: [ParsedBatter]].self, forKey: .battersDict)
    }
}

// MARK: - Codable, Hashable, Equatable

extension PlayerPool {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(battersDict, forKey: .battersDict)
    }

    private enum CodingKeys: String, CodingKey {
        case battersDict
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(battersDict)
    }

    static func == (lhs: PlayerPool, rhs: PlayerPool) -> Bool {
        return lhs.battersDict == rhs.battersDict
    }
}
