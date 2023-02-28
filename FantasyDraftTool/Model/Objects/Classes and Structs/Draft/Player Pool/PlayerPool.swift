//
//  PlayerPool.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/1/23.
//

import Foundation

typealias PitchersByType = [PitcherType: [ParsedPitcher]]
typealias PitchersByTypeByProjection = [ProjectionTypes: PitchersByType]

// MARK: - PlayerPool

struct PlayerPool: Codable, Hashable, Equatable {
    // MARK: - Stored Properties

//    var batters: [ParsedBatter] {
//        return self.storedBatters
//        var retArr: [ParsedBatter] = []
//        for position in Position.batters {
//            if let battersAtPosition = battersDict[position] {
//                retArr += battersAtPosition
//            }
//        }
//        return retArr.removingDuplicates()
//    }

    var positionsOrder: [Position] = Position.batters

//    var battersDict: [Position: [ParsedBatter]] = {
//        var retDict: [Position: [ParsedBatter]] = [:]
//
//        for position in Position.batters {
//            var theseBatters: [ParsedBatter] = []
//            for projectionType in ProjectionTypes.batterArr {
//                let battersForThisPosition = AllExtendedBatters.batters(for: projectionType, at: position, limit: 50)
//                theseBatters += battersForThisPosition
//            }
//
//            retDict[position] = theseBatters.sortedByPoints
//        }
//
//        return retDict
//    }()

    var storedBatters: StoredBatters
    var storedPitchers: StoredPitchers

    func allStoredPlayers(projection: ProjectionTypes, scoring: ScoringSettings, batterLimit: Int, pitcherLimit: Int, sort: Bool, completion: @escaping ([any ParsedPlayer]) -> Void) {
        DispatchQueue.global().async {
            let batters = storedBatters.batters(for: projection).sortedByPoints(scoring: scoring).prefixArray(batterLimit)
            let pitchers = storedPitchers.pitchers(for: projection).sortedByPoints(scoring: scoring).prefixArray(pitcherLimit)
            let union: [any ParsedPlayer] = (batters + pitchers)
            if !sort {
                completion(union)
                return
            }
            let sorted = union.sorted { player1, player2 in
                player1.fantasyPoints(scoring) > player2.fantasyPoints(scoring)
            }
            completion(sorted)
        }
    }

    func allStoredPlayers(projection: ProjectionTypes, scoring: ScoringSettings, batterLimit: Int, pitcherLimit: Int, sort: Bool) async -> [any ParsedPlayer] {
        let batters =  storedBatters.batters(for: projection).sortedByPoints(scoring: scoring).prefixArray(batterLimit)
        let pitchers = storedPitchers.pitchers(for: projection).sortedByPoints(scoring: scoring).prefixArray(pitcherLimit)
        let union: [any ParsedPlayer] = (batters + pitchers)
        if !sort {
            return union
        }
        let sorted =  union.sorted { player1, player2 in
            player1.fantasyPoints(scoring) > player2.fantasyPoints(scoring)
        } 
        return sorted
    }

//    func allStoredPlayers(projection: ProjectionTypes) [any ParsedPlayer] {
    ////        storedBatters.batters(for: projection) + storedPitchers.
//    }

//    var pitchersDict: [ProjectionTypes]

//    var allPlayers: [ProjectionTypes: Any]

//    var battersByProjection: [ProjectionTypes: [Position: [ParsedBatter]]] = {
//        var retDict: [ProjectionTypes: [Position: [ParsedBatter]]] = [:]
//
//        return retDict
//
//
//    }()
//

    var pitchersByProjection: PitchersByTypeByProjection = {
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

        return retDict

    }()

    func batters(for positions: [Position], projection: ProjectionTypes, draft: Draft = MainModel.shared.draft) -> [ParsedBatter] {
        var retArr = [ParsedBatter]()

        for position in positions {
            retArr += storedBatters.batters(for: projection, at: position)

//            if let battersArr = battersDict[position] {
//                for batter in battersArr {
//                    if batter.projectionType == projection {
//                        retArr.append(batter)
//                    }
//                }
//            }
        }

        return retArr.sortedByZscore(draft: draft)
    }

//    func getBattersDict() -> [Position: [ParsedBatter]] {
//        battersDict
//    }

//    func getPositionAveragesDict() -> [Position: Double] {
//        positionAveragesDict
//    }

//    var positionAveragesDict: [Position: Double] = emptyPosAverageDict()

//    var standardDeviationDict: [Position: Double] = {
//        var dict: [Position: Double] = [:]
//
//        var tempDict: [Position: [ParsedBatter]] = [:]
//
//        for position in Position.batters {
//            let battersForThisPosition = AllExtendedBatters.batters(for: .steamer, at: position, limit: UserDefaults.positionLimit)
//            tempDict[position] = battersForThisPosition.sortedByPoints
//        }
//
//        for position in Position.batters {
//            guard let players = tempDict[position] else { continue }
//            dict[position] = players.standardDeviation(for: position)
//        }
//
//        return dict
//
//    }()

    func positionRank(for player: ParsedBatter, at position: Position) -> Int? {
//        guard let batters = battersDict[position]?.sortedByPoints,
//              let indexFound = batters.firstIndex(of: player) else {
//            return nil
//        }
        let batters = storedBatters.batters(for: player.projectionType, at: position)
        guard let indexFound = batters.firstIndex(of: player) else { return nil }
        return indexFound + 1
    }

//    static func emptyPosAverageDict() -> [Position: Double] {
//        var retDict: [Position: Double] = [:]
//
//        for position in Position.batters {
//            let battersForThisPosition = AllExtendedBatters.batters(for: .steamer, at: position, limit: UserDefaults.positionLimit)
//            retDict[position] = ParsedBatter.averagePoints(forThese: battersForThisPosition, scoring: <#ScoringSettings#>)
//        }
//
//        return retDict
//    }

    // MARK: - Methods

//    mutating func updateDicts(for positions: [Position]? = nil) {
//        updateStandardDeviationDict()
//        if let positions = positions {
//            recalculateDict(for: positions)
//        }
//    }
//
//    mutating func recalculateDict() {
//        for pos in battersDict.keys {
//            if let posBatters = battersDict[pos] {
//                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
//            }
//        }
//    }

//    mutating func recalculateDict(for positions: [Position]) {
//        for pos in positions {
//            if let posBatters = battersDict[pos] {
//                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
//            }
//        }
//    }

//    mutating func updateStandardDeviationDict() {
//        for position in positionsOrder {
//            guard let players = battersDict[position] else { continue }
//            standardDeviationDict[position] = players.standardDeviation(for: position)
//        }
//    }

//    mutating func setPositionsOrder() {
//        let v = positionsOrder
//        positionsOrder = v.sorted(by: { positionAveragesDict[$0] ?? 0 > positionAveragesDict[$1] ?? 0 })
//    }

    // MARK: - Initializers

    init(scoring: ScoringSettings) {
        self.storedPitchers = .init(scoring: scoring)
        self.storedBatters = .init(scoring: scoring)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storedBatters = try container.decode(StoredBatters.self, forKey: .storedBatters)
        self.storedPitchers = try container.decode(StoredPitchers.self, forKey: .storedPitchers)
//        self.battersDict = try container.decode([Position: [ParsedBatter]].self, forKey: .battersDict)
    }
}

// MARK: - Codable, Hashable, Equatable

extension PlayerPool {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(battersDict, forKey: .battersDict)
        try container.encode(storedBatters, forKey: .storedBatters)
        try container.encode(storedPitchers, forKey: .storedPitchers)
//        try container.encode(pitchersByProjection, forKey: .pitchersDict)
    }

    private enum CodingKeys: String, CodingKey {
        case battersDict, pitchersDict, storedBatters, storedPitchers
    }

    func hash(into hasher: inout Hasher) {
//        hasher.combine(battersDict)
        hasher.combine(pitchersByProjection)
    }

    static func == (lhs: PlayerPool, rhs: PlayerPool) -> Bool {
        true
//        return lhs.battersDict == rhs.battersDict
    }
}

extension PlayerPool {
    struct StoredBatters: Codable {
        var atc, steamer, theBat, depthCharts, thebatx: StoreProjectionBatters

        // Coding keys for the struct's properties
        enum CodingKeys: String, CodingKey {
            case atc
            case steamer
            case theBat
            case depthCharts
            case thebatx
        }

        // Encoding method
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(atc, forKey: .atc)
            try container.encode(steamer, forKey: .steamer)
            try container.encode(theBat, forKey: .theBat)
            try container.encode(depthCharts, forKey: .depthCharts)
            try container.encode(thebatx, forKey: .thebatx)
        }

        // Decoding method
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.atc = try container.decode(StoreProjectionBatters.self, forKey: .atc)
            self.steamer = try container.decode(StoreProjectionBatters.self, forKey: .steamer)
            self.theBat = try container.decode(StoreProjectionBatters.self, forKey: .theBat)
            self.depthCharts = try container.decode(StoreProjectionBatters.self, forKey: .depthCharts)
            self.thebatx = try container.decode(StoreProjectionBatters.self, forKey: .thebatx)
        }

        init(scoring: ScoringSettings) {
            self.atc = .init(projectionType: .atc, scoring: scoring)
            self.steamer = .init(projectionType: .steamer, scoring: scoring)
            self.theBat = .init(projectionType: .thebat, scoring: scoring)
            self.depthCharts = .init(projectionType: .depthCharts, scoring: scoring)
            self.thebatx = .init(projectionType: .thebatx, scoring: scoring)
        }

        func average(for projection: ProjectionTypes, at position: Position) -> Double {
            switch projection {
                case .steamer:
                    return steamer.averages.forPosition(position)
                case .thebat:
                    return theBat.averages.forPosition(position)
                case .thebatx:
                    return thebatx.averages.forPosition(position)
                case .atc:
                    return atc.averages.forPosition(position)
                case .depthCharts:
                    return depthCharts.averages.forPosition(position)
                default:
                    return -99
            }
        }

        func stdDev(for projection: ProjectionTypes, at position: Position) -> Double {
            switch projection {
                case .steamer:
                    return steamer.stdDevs.forPosition(position)
                case .thebat:
                    return theBat.stdDevs.forPosition(position)
                case .thebatx:
                    return thebatx.stdDevs.forPosition(position)
                case .atc:
                    return atc.stdDevs.forPosition(position)
                case .depthCharts:
                    return depthCharts.stdDevs.forPosition(position)
                default:
                    return -99
            }
        }

        func batters(for projection: ProjectionTypes, at position: Position) -> [ParsedBatter] {
            let storedProjection: StoreProjectionBatters
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = theBat
                case .thebatx:
                    storedProjection = thebatx
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
            }
            return storedProjection.batters(for: position)
        }

        func batters(for projection: ProjectionTypes) -> [ParsedBatter] {
            let storedProjection: StoreProjectionBatters
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = theBat
                case .thebatx:
                    storedProjection = thebatx
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
            }
            return storedProjection.all
        }

        mutating func add(_ batter: ParsedBatter, to projection: ProjectionTypes, for position: Position, scoring: ScoringSettings) {
            var storedProjection: StoreProjectionBatters
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = theBat
                case .thebatx:
                    storedProjection = thebatx
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
            }
            storedProjection.add(batter: batter, to: position, scoring: scoring)
            switch projection {
                case .steamer:
                    steamer = storedProjection
                case .myProjections, .zips:
                    steamer = storedProjection
                case .thebat:
                    theBat = storedProjection
                case .thebatx:
                    thebatx = storedProjection
                case .atc:
                    atc = storedProjection
                case .depthCharts:
                    depthCharts = storedProjection
            }
        }

        mutating func remove(_ batter: ParsedBatter, from projection: ProjectionTypes, scoring: ScoringSettings) {
            var storedProjection: StoreProjectionBatters
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = theBat
                case .thebatx:
                    storedProjection = thebatx
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
            }
            storedProjection.remove(batter: batter, scoring: scoring)
            switch projection {
                case .steamer:
                    steamer = storedProjection
                case .myProjections, .zips:
                    steamer = storedProjection
                case .thebat:
                    theBat = storedProjection
                case .thebatx:
                    thebatx = storedProjection
                case .atc:
                    atc = storedProjection
                case .depthCharts:
                    depthCharts = storedProjection
            }
        }
    }

    struct StoreProjectionBatters: Codable {
        var firstBase: [ParsedBatter] = []
        var secondBase: [ParsedBatter] = []
        var thirdBase: [ParsedBatter] = []
        var shortstop: [ParsedBatter] = []
        var outfield: [ParsedBatter] = []
        var catcher: [ParsedBatter] = []
        var all: [ParsedBatter] { firstBase + secondBase + thirdBase + shortstop + outfield + catcher }

        var averages: Averages
        var stdDevs: StandardDevations

        // Coding keys for the struct's properties
        enum CodingKeys: String, CodingKey {
            case firstBase
            case secondBase
            case thirdBase
            case shortstop
            case outfield
            case catcher
            case averages
            case stdDevs
        }

        // Encoding method
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(firstBase, forKey: .firstBase)
            try container.encode(secondBase, forKey: .secondBase)
            try container.encode(thirdBase, forKey: .thirdBase)
            try container.encode(shortstop, forKey: .shortstop)
            try container.encode(outfield, forKey: .outfield)
            try container.encode(catcher, forKey: .catcher)
            try container.encode(averages, forKey: .averages)
            try container.encode(stdDevs, forKey: .stdDevs)
        }

        // Decoding method
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.firstBase = try container.decode([ParsedBatter].self, forKey: .firstBase)
            self.secondBase = try container.decode([ParsedBatter].self, forKey: .secondBase)
            self.thirdBase = try container.decode([ParsedBatter].self, forKey: .thirdBase)
            self.shortstop = try container.decode([ParsedBatter].self, forKey: .shortstop)
            self.outfield = try container.decode([ParsedBatter].self, forKey: .outfield)
            self.catcher = try container.decode([ParsedBatter].self, forKey: .catcher)
            self.averages = try container.decode(Averages.self, forKey: .averages)
            self.stdDevs = try container.decode(StandardDevations.self, forKey: .stdDevs)
        }

        struct Averages: Codable {
            var first, second, third, short, catcher, outfield: Double

            func forPosition(_ position: Position) -> Double {
                switch position {
                    case .c:
                        return catcher
                    case .first:
                        return first
                    case .second:
                        return second
                    case .third:
                        return third
                    case .ss:
                        return short
                    case .of:
                        return outfield
                    default:
                        return -99
                }
            }
        }

        struct StandardDevations: Codable {
            var first, second, third, short, catcher, outfield: Double

            func forPosition(_ position: Position) -> Double {
                switch position {
                    case .c:
                        return catcher
                    case .first:
                        return first
                    case .second:
                        return second
                    case .third:
                        return third
                    case .ss:
                        return short
                    case .of:
                        return outfield
                    default:
                        return -99
                }
            }
        }

        init(projectionType: ProjectionTypes, scoring: ScoringSettings) {
            let firstBase = AllParsedBatters.batters(for: projectionType, at: .first)
            let secondBase = AllParsedBatters.batters(for: projectionType, at: .second)
            let thirdBase = AllParsedBatters.batters(for: projectionType, at: .third)
            let shortstop = AllParsedBatters.batters(for: projectionType, at: .ss)
            let outfield = AllParsedBatters.batters(for: projectionType, at: .of)
            let catcher = AllParsedBatters.batters(for: projectionType, at: .c)

            self.firstBase = firstBase
            self.secondBase = secondBase
            self.thirdBase = thirdBase
            self.shortstop = shortstop
            self.outfield = outfield
            self.catcher = catcher

            self.averages = .init(first: ParsedBatter.averagePoints(forThese: firstBase, scoring: scoring),
                                  second: ParsedBatter.averagePoints(forThese: secondBase, scoring: scoring),
                                  third: ParsedBatter.averagePoints(forThese: thirdBase, scoring: scoring),
                                  short: ParsedBatter.averagePoints(forThese: shortstop, scoring: scoring),
                                  catcher: ParsedBatter.averagePoints(forThese: catcher, scoring: scoring),
                                  outfield: ParsedBatter.averagePoints(forThese: outfield, scoring: scoring))

            self.stdDevs = .init(first: firstBase.standardDeviation(for: .first, scoring: scoring),
                                 second: secondBase.standardDeviation(for: .second, scoring: scoring),
                                 third: thirdBase.standardDeviation(for: .third, scoring: scoring),
                                 short: shortstop.standardDeviation(for: .ss, scoring: scoring),
                                 catcher: catcher.standardDeviation(for: .c, scoring: scoring),
                                 outfield: outfield.standardDeviation(for: .of, scoring: scoring))
        }

        mutating func add(batter: ParsedBatter, to position: Position, scoring: ScoringSettings) {
            switch position {
                case .c:
                    catcher.append(batter)
                case .first:
                    firstBase.append(batter)
                case .second:
                    secondBase.append(batter)
                case .third:
                    thirdBase.append(batter)
                case .ss:
                    shortstop.append(batter)
                case .of:
                    outfield.append(batter)
                case .dh:
                    return
                case .rp, .sp:
                    return
            }
            update(position: position, scoring: scoring)
        }

        mutating func remove(batter: ParsedBatter, scoring: ScoringSettings) {
            for position in batter.positions {
                switch position {
                    case .c:
                        catcher.removeAll(where: { $0.name == batter.name })
                    case .first:
                        firstBase.removeAll(where: { $0.name == batter.name })
                    case .second:
                        secondBase.removeAll(where: { $0.name == batter.name })
                    case .third:
                        thirdBase.removeAll(where: { $0.name == batter.name })
                    case .ss:
                        shortstop.removeAll(where: { $0.name == batter.name })
                    case .of:
                        outfield.removeAll(where: { $0.name == batter.name })
                    default:
                        break
                }
                update(position: position, scoring: scoring)
            }
        }

        /// To be called after the position array has been mutated
        mutating func update(position: Position, scoring: ScoringSettings) {
            switch position {
                case .c:
                    averages.catcher = ParsedBatter.averagePoints(forThese: catcher, scoring: scoring)
                    stdDevs.catcher = catcher.standardDeviation(for: .c, scoring: scoring)
                case .first:
                    averages.first = ParsedBatter.averagePoints(forThese: firstBase, scoring: scoring)
                    stdDevs.first = catcher.standardDeviation(for: .first, scoring: scoring)
                case .second:
                    averages.second = ParsedBatter.averagePoints(forThese: secondBase, scoring: scoring)
                    stdDevs.second = catcher.standardDeviation(for: .second, scoring: scoring)
                case .third:
                    averages.third = ParsedBatter.averagePoints(forThese: thirdBase, scoring: scoring)
                    stdDevs.third = catcher.standardDeviation(for: .third, scoring: scoring)
                case .ss:
                    averages.short = ParsedBatter.averagePoints(forThese: shortstop, scoring: scoring)
                    stdDevs.short = catcher.standardDeviation(for: .ss, scoring: scoring)
                case .of:
                    averages.outfield = ParsedBatter.averagePoints(forThese: outfield, scoring: scoring)
                    stdDevs.outfield = catcher.standardDeviation(for: .of, scoring: scoring)
                default:
                    return
            }
        }

        func batters(for position: Position) -> [ParsedBatter] {
            switch position {
                case .c:
                    return catcher
                case .first:
                    return firstBase
                case .second:
                    return secondBase
                case .third:
                    return thirdBase
                case .ss:
                    return shortstop
                case .of:
                    return outfield
                case .dh:
                    return []
                case .sp:
                    return []
                case .rp:
                    return []
            }
        }
    }

    struct StoredPitchers: Codable {
        var atc, steamer, thebat, depthCharts: StoredProjectionPitchers

        init(scoring: ScoringSettings) {
            self.atc = .init(projectionType: .atc, scoring: scoring)
            self.steamer = .init(projectionType: .steamer, scoring: scoring)
            self.thebat = .init(projectionType: .thebat, scoring: scoring)
            self.depthCharts = .init(projectionType: .depthCharts, scoring: scoring)
        }

        // Coding keys for the struct's properties
        enum CodingKeys: String, CodingKey {
            case atc
            case steamer
            case theBat
            case depthCharts
        }

        // Encoding method
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(atc, forKey: .atc)
            try container.encode(steamer, forKey: .steamer)
            try container.encode(thebat, forKey: .theBat)
            try container.encode(depthCharts, forKey: .depthCharts)
        }

        // Decoding method
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.atc = try container.decode(StoredProjectionPitchers.self, forKey: .atc)
            self.steamer = try container.decode(StoredProjectionPitchers.self, forKey: .steamer)
            self.thebat = try container.decode(StoredProjectionPitchers.self, forKey: .theBat)
            self.depthCharts = try container.decode(StoredProjectionPitchers.self, forKey: .depthCharts)
        }

        func average(for projection: ProjectionTypes, at type: PitcherType) -> Double {
            switch projection {
                case .steamer:
                    return type == .starter ? steamer.averages.sp : steamer.averages.rp
                case .thebat:
                    return type == .starter ? thebat.averages.sp : thebat.averages.rp

                case .atc:
                    return type == .starter ? atc.averages.sp : atc.averages.rp
                case .depthCharts:
                    return type == .starter ? depthCharts.averages.sp : depthCharts.averages.rp
                default:
                    return -99
            }
        }

        func stdDev(for projection: ProjectionTypes, type: PitcherType) -> Double {
            switch projection {
                case .steamer:
                    return type == .starter ? steamer.stdDevs.sp : steamer.stdDevs.rp
                case .thebat:
                    return type == .starter ? thebat.stdDevs.sp : thebat.stdDevs.rp

                case .atc:
                    return type == .starter ? atc.stdDevs.sp : atc.stdDevs.rp
                case .depthCharts:
                    return type == .starter ? depthCharts.stdDevs.sp : depthCharts.stdDevs.rp
                default:
                    return -99
            }
        }

        func batters(for projection: ProjectionTypes, at type: PitcherType) -> [ParsedPitcher] {
            pitchers(for: projection).filter { $0.type == type }
        }

        func pitchers(for projection: ProjectionTypes) -> [ParsedPitcher] {
            let storedProjection: StoredProjectionPitchers
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = thebat
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
                default:
                    return []
            }
            return storedProjection.all
        }

        mutating func add(_ pitcher: ParsedPitcher, to projection: ProjectionTypes, scoring: ScoringSettings) {
            var storedProjection: StoredProjectionPitchers
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = thebat
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
                default:
                    return
            }
            storedProjection.add(pitcher: pitcher, scoring: scoring)
            switch projection {
                case .steamer:
                    steamer = storedProjection
                case .myProjections, .zips:
                    steamer = storedProjection
                case .thebat:
                    thebat = storedProjection
                case .atc:
                    atc = storedProjection
                case .depthCharts:
                    depthCharts = storedProjection
                default:
                    return
            }
        }

        mutating func remove(_ pitcher: ParsedPitcher, from projection: ProjectionTypes, scoring: ScoringSettings) {
            var storedProjection: StoredProjectionPitchers
            switch projection {
                case .steamer:
                    storedProjection = steamer
                case .myProjections, .zips:
                    storedProjection = steamer
                case .thebat:
                    storedProjection = thebat
                case .atc:
                    storedProjection = atc
                case .depthCharts:
                    storedProjection = depthCharts
                default:
                    return
            }
            storedProjection.remove(pitcher: pitcher, scoring: scoring)
            switch projection {
                case .steamer:
                    steamer = storedProjection
                case .myProjections, .zips:
                    steamer = storedProjection
                case .thebat:
                    thebat = storedProjection
                case .atc:
                    atc = storedProjection
                case .depthCharts:
                    depthCharts = storedProjection
                default:
                    return
            }
        }
    }

    struct StoredProjectionPitchers: Codable {
        var relievers: [ParsedPitcher] = []
        var starters: [ParsedPitcher] = []

        var all: [ParsedPitcher] { starters + relievers }

        var averages: Averages
        var stdDevs: StandardDevations

        // Coding keys for the struct's properties
        enum CodingKeys: String, CodingKey {
            case sp, rp
            case averages
            case stdDevs
        }

        // Encoding method
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(starters, forKey: .sp)
            try container.encode(relievers, forKey: .rp)
            try container.encode(averages, forKey: .averages)
            try container.encode(stdDevs, forKey: .stdDevs)
        }

        // Decoding method
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.starters = try container.decode([ParsedPitcher].self, forKey: .sp)
            self.relievers = try container.decode([ParsedPitcher].self, forKey: .rp)

            self.averages = try container.decode(Averages.self, forKey: .averages)
            self.stdDevs = try container.decode(StandardDevations.self, forKey: .stdDevs)
        }

        struct Averages: Codable {
            var sp, rp: Double
        }

        struct StandardDevations: Codable {
            var sp, rp: Double
        }

        init(projectionType: ProjectionTypes, scoring: ScoringSettings) {
            let sp = AllExtendedPitchers.starters(for: projectionType, limit: 150)
            let rp = AllExtendedPitchers.relievers(for: projectionType, limit: 150)

            self.starters = sp
            self.relievers = rp

            self.averages = .init(sp: ParsedPitcher.averagePoints(forThese: sp, scoringSettings: scoring), rp: ParsedPitcher.averagePoints(forThese: rp, scoringSettings: scoring))

            self.stdDevs = .init(sp: sp.standardDeviation(scoring: scoring), rp: rp.standardDeviation(scoring: scoring))
        }

        mutating func add(pitcher: ParsedPitcher, scoring: ScoringSettings) {
            switch pitcher.type {
                case .reliever:
                    relievers.append(pitcher)
                case .starter:
                    relievers.append(pitcher)
            }
            update(type: pitcher.type, scoring: scoring)
        }

        mutating func remove(pitcher: ParsedPitcher, scoring: ScoringSettings) {
            switch pitcher.type {
                case .reliever:
                    relievers.removeAll(where: { $0.name == pitcher.name })
                case .starter:
                    starters.removeAll(where: { $0.name == pitcher.name })
            }
            update(type: pitcher.type, scoring: scoring)
        }

        /// To be called after the position array has been mutated
        mutating func update(type: PitcherType, scoring: ScoringSettings) {
            switch type {
                case .starter:
                    averages.sp = ParsedPitcher.averagePoints(forThese: starters, scoringSettings: scoring)
                    stdDevs.sp = starters.standardDeviation(scoring: scoring)
                case .reliever:
                    averages.rp = ParsedPitcher.averagePoints(forThese: starters, scoringSettings: scoring)
                    stdDevs.rp = starters.standardDeviation(scoring: scoring)
            }
        }

        func pitchers(for type: PitcherType) -> [ParsedPitcher] {
            switch type {
                case .starter:
                    return starters
                case .reliever:
                    return relievers
            }
        }
    }
}
