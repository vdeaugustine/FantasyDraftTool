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
            var theseBatters: [ParsedBatter] = []
            for projectionType in ProjectionTypes.batterArr {
                let battersForThisPosition = AllExtendedBatters.batters(for: projectionType, at: position, limit: 50)
                theseBatters += battersForThisPosition
            }

            retDict[position] = theseBatters.sortedByPoints
        }

        return retDict
    }()
    
    typealias PitchersByType = [PitcherType: [ParsedPitcher]]
    typealias PitchersByTypeByProjection = [ProjectionTypes: PitchersByType]
    
    
    var pitchersDict: PitchersByTypeByProjection = {
        var retDict: PitchersByTypeByProjection = [:]
        
        
        var serializedDict: [String: [String: [ParsedPitcher]]] = [:]
        
        for projection in ProjectionTypes.pitcherArr {
            var byType: PitchersByType = [:]
            let rel = AllExtendedPitchers.relievers(for: projection, limit: 100)
            let sta = AllExtendedPitchers.starters(for: projection, limit: 100)
            byType[.starter] = sta
            byType[.reliever] = rel
            var firstSerDict: [String: [ParsedPitcher]] = [:]
            firstSerDict[PitcherType.starter.str] = sta
            firstSerDict[PitcherType.reliever.str] = rel
            serializedDict[projection.str] = firstSerDict
            retDict[projection] = byType
        }
        

        func printDictionaryAsJSON(_ dictionary: [String: Any], withIndent indent: Int = 0) {
            let indentString = String(repeating: " ", count: indent * 4)
            let comma = (indent > 0) ? "," : ""

            print("{")
            for (key, value) in dictionary.sorted(by: { $0.key < $1.key }) {
                if let nestedDictionary = value as? [String: Any] {
                    print("\(indentString)\"\(key)\":", terminator: " ")
                    printDictionaryAsJSON(nestedDictionary, withIndent: indent + 1)
                } else {
                    let valueString = "\(value)".replacingOccurrences(of: "\"", with: "\\\"")
                    print("\(indentString)\"\(key)\": \"\(valueString)\"\(comma)")
                }
            }
            print("\(String(repeating: " ", count: (indent - 1) * 4))}")
        }

        
        print(serializedDict)
        
        
        
        return retDict
        
        
    }()

    func batters(for positions: [Position], projection: ProjectionTypes, draft: Draft = MainModel.shared.draft) -> [ParsedBatter] {
        var retArr = [ParsedBatter]()

        for position in positions {
            if let battersArr = battersDict[position] {
                for batter in battersArr {
                    if batter.projectionType == projection {
                        retArr.append(batter)
                    }
                }
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
            let battersForThisPosition = AllExtendedBatters.batters(for: .steamer, at: position, limit: UserDefaults.positionLimit)
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
            let battersForThisPosition = AllExtendedBatters.batters(for: .steamer, at: position, limit: UserDefaults.positionLimit)
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
        try container.encode(pitchersDict, forKey: .pitchersDict)
    }

    private enum CodingKeys: String, CodingKey {
        case battersDict, pitchersDict
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(battersDict)
        hasher.combine(pitchersDict)
    }

    static func == (lhs: PlayerPool, rhs: PlayerPool) -> Bool {
        return lhs.battersDict == rhs.battersDict
    }
}
