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
        return retArr.removingDuplicates()
    }

    var positionsOrder: [Position] = Position.batters

    var battersDict: [Position: [ParsedBatter]] = {
        var retDict: [Position: [ParsedBatter]] = [:]

        for position in Position.batters {
            let battersForThisPosition = AllParsedBatters.batters(for: .steamer, at: position)
            retDict[position] = battersForThisPosition.sortedByPoints
        }

        return retDict
    }()

    func batters(for positions: [Position], draft: Draft = MainModel.shared.draft) -> [ParsedBatter] {
        var retArr = [ParsedBatter]()

        for position in positions {
            if let battersArr = battersDict[position] {
                retArr += battersArr
            }
        }

        return retArr.sortedByZscore(draft: draft)
    }

    func getBattersDict() -> [Position: [ParsedBatter]] {
        battersDict
    }

    func getPositionAveragesDict() -> [Position: Double] {
        positionAveragesDict
    }

    var positionAveragesDict: [Position: Double] = emptyPosAverageDict()

    var standardDeviationDict: [Position: Double] = {
        var dict: [Position: Double] = [:]

        var tempDict: [Position: [ParsedBatter]] = [:]

        for position in Position.batters {
            let battersForThisPosition = AllParsedBatters.batters(for: .steamer, at: position)
            tempDict[position] = battersForThisPosition.sortedByPoints
        }

        for position in Position.batters {
            guard let players = tempDict[position] else { continue }
            dict[position] = players.standardDeviation(for: position)
        }

        return dict

    }()

    func positionRank(for player: ParsedBatter, at position: Position) -> Int? {
        guard let batters = battersDict[position]?.sortedByPoints,
              let indexFound = batters.firstIndex(of: player) else {
            return nil
        }
        return indexFound + 1
    }

    static func emptyPosAverageDict() -> [Position: Double] {
        var retDict: [Position: Double] = [:]

        for position in Position.batters {
            let battersForThisPosition = AllParsedBatters.batters(for: .steamer, at: position)
            retDict[position] = ParsedBatter.averagePoints(forThese: battersForThisPosition)
        }

        return retDict
    }

    // MARK: - Methods

    mutating func updateDicts(for positions: [Position]? = nil) {
        updateStandardDeviationDict()
        if let positions = positions {
            recalculateDict(for: positions)
        }
    }

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

    mutating func updateStandardDeviationDict() {
        for position in positionsOrder {
            guard let players = battersDict[position] else { continue }
            standardDeviationDict[position] = players.standardDeviation(for: position)
        }
    }

    mutating func setPositionsOrder() {
        let v = positionsOrder
        positionsOrder = v.sorted(by: { positionAveragesDict[$0] ?? 0 > positionAveragesDict[$1] ?? 0 })
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
