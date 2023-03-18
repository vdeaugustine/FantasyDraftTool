

//
//  ParsedBatter.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import Foundation

// MARK: - ParsedPlayer

protocol ParsedPlayer: Codable {
    var name: String { get set }
    var team: String { get set }
    var adp: Double? { get }
    var projectionType: ProjectionTypes { get }

    var dict: [String: Any] { get }

    func zScore(draft: Draft) -> Double
    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double
    func weightedFantasyPoints(draft: Draft, limit: Int) -> Double
    func averageForPosition(limit: Int, draft: Draft) -> Double

    func wPointsZScore(draft: Draft) -> Double

    func posStr() -> String

    func samePlayer(for: ProjectionTypes) -> ParsedPlayer?

    var isStarred: Bool { get set }
    var starHasBeenSetAtLeastOnce: Bool { get set }
}

// MARK: - AnyParsedPlayer

struct AnyParsedPlayer<T: ParsedPlayer> {
}

// MARK: - ParsedBatter

struct ParsedBatter: Hashable, Codable, Identifiable, CustomStringConvertible, ParsedPlayer {
    var starHasBeenSetAtLeastOnce: Bool = false

    var isStarred: Bool = false

    func samePlayer(for projection: ProjectionTypes) -> ParsedPlayer? {
        let allPlayers: [ParsedBatter]
        switch projection {
            case .steamer:
                allPlayers = AllExtendedBatters.steamer.all
            case .thebat:
                allPlayers = AllExtendedBatters.theBat.all
            case .thebatx:
                allPlayers = AllExtendedBatters.theBatx.all
            case .atc:
                allPlayers = AllExtendedBatters.atc.all
            case .depthCharts:
                allPlayers = AllExtendedBatters.depthCharts.all
            case .myProjections, .zips:
                allPlayers = []
        }

        return allPlayers.first(where: { $0.name == self.name && $0.team == self.team })
    }

    func averageForPosition(limit: Int, draft: Draft) -> Double {
        guard let firstPos = positions.first else { return 0 }
        let allPlayers = draft.playerPool.storedBatters.batters(for: projectionType, at: firstPos)
        let sorted = allPlayers.sortedByPoints(scoring: draft.settings.scoringSystem)
        let top = sorted.prefixArray(limit)
        let sum: Double = top.reduce(0) { partial, element in
            partial + element.fantasyPoints(draft.settings.scoringSystem)
        }
        return sum / Double(top.count)
    }

    // MARK: Stored Properties

    var empty, name, team: String
    var g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs: Int
    var avg: Double
    let positions: [Position]
    let projectionType: ProjectionTypes
    let adp: Double?

    var description: String {
        [name, team, projectionType.title, adp?.str ?? "NO ADP"].joined(separator: ", ")
    }

    // MARK: Computed properties

    var id: String { name + team + posStr() }

    var tb: Double {
        Double(the1B) + (2 * Double(the2B)) + (3 * Double(the3B)) + (4 * Double(hr))
    }

    var dict: [String: Any] {
        ["Name": name,
         "Team": team,
         "G": g,
         "AB": ab,
         "PA": pa,
         "H": h,
         "1B": the1B,
         "2B": the2B,
         "3B": the3B,
         "HR": hr,
         "R": r,
         "RBI": rbi,
         "BB": bb,
         "IBB": ibb,
         "SO": so,
         "HBP": hbp,
         "SF": sf,
         "SH": sh,
         "SB": sb,
         "CS": cs,
         "AVG": avg]
    }

    var relevantStatsKeys: [String] {
        ["G",
         "AB",
         "PA",
         "H",
         "1B",
         "2B",
         "3B",
         "R",
         "RBI",
         "BB",
         "SO",
         "HBP",
         "SB",
         "CS"]
    }

    var relevantStatsValues: [Int] {
        relevantStatsKeys.compactMap { str in
            Int(str)
        }
    }

    func adpStr() -> String? {
        guard let adp = adp else { return nil }
        let rounded = adp.roundTo(places: 1)
        if rounded == Double(Int(rounded)) {
            return Int(rounded).str
        }
        return rounded.str()
    }

    static let TroutOrNull: ParsedBatter = AllParsedBatters.atc.of.first(where: { $0.name.lowercased().contains("trout") }) ?? .nullBatter

    static func player(by name: String) -> ParsedBatter {
        for proj in ProjectionTypes.batterArr {
            if let found = AllParsedBatters.batters(for: proj).first(where: { $0.name.lowercased().contains(name.lowercased()) }) {
                return found
            }
        }
        return .nullBatter
    }

    // MARK: - Static Properties

    static let nullBatter: ParsedBatter = .init(empty: "", name: "", team: "", g: 0, ab: 0, pa: 0, h: 0, the1B: 0, the2B: 0, the3B: 0, hr: 0, r: 0, rbi: 0, bb: 0, ibb: 0, so: 0, hbp: 0, sf: 0, sh: 0, sb: 0, cs: 0, avg: 0, positions: [], projectionType: .steamer, adp: nil)

    // MARK: - Mutating Methods

    mutating func edit(_ stat: String, with newValue: Int) {
//        print("editing: \(stat) from \(dict[stat] as! Int) with \(newValue)")
        switch stat {
            case "G":
                g = newValue
            case "AB":
                ab = newValue
            case "PA":
                pa = newValue
            case "H":
                h = newValue
            case "1B":
                the1B = newValue
            case "2B":
                the2B = newValue
            case "3B":
                the3B = newValue
            case "R":
                r = newValue
            case "RBI":
                rbi = newValue
            case "BB":
                bb = newValue
            case "SO":
                so = newValue
            case "HBP":
                hbp = newValue
            case "SB":
                sb = newValue
            case "CS":
                cs = newValue
            default:
                break
        }
    }

    // MARK: Methods

    func posStr() -> String {
        var retStr: String = ""
        for position in positions {
            retStr += ", " + position.str.uppercased()
        }
        return retStr.removeExtraneousMarks()
    }

    func weightedFantasyPoints(positionAverage: Double) -> Double {
        fantasyPoints(MainModel.shared.getScoringSettings()) / positionAverage * fantasyPoints(MainModel.shared.getScoringSettings())
    }

    func zScore(draft: Draft, limit: Int) -> Double {
        guard let firstPos = positions.first else {
            return 0
        }
        let average = draft.playerPool.storedBatters.average(for: projectionType, at: firstPos)
        let stdDev = draft.playerPool.storedBatters.stdDev(for: projectionType, at: firstPos)

        guard stdDev != 0 else { return 0 }
        let zScore = (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev

        return zScore
    }

    /// Gives the zScore of the batter by comparing them to only players of the same position that have an ADP better or equal to the total number of picks in the draft. Essentially players that will realistically be drafted
    func zScore(draft: Draft) -> Double {
        let smallerPool: [ParsedBatter] = peers(draft: draft)

        let average = ParsedBatter.averagePoints(forThese: smallerPool, scoring: draft.settings.scoringSystem)
        let stdDev = smallerPool.standardDeviation(scoring: draft.settings.scoringSystem)

        let zScore = (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev

        return zScore
    }

    /// Returns remaining players in the draft pool *playing same position* that have an ADP better or equal to the total number of picks in the draft. Essentially players that will realistically be drafted
    func peers(draft: Draft) -> [ParsedBatter] {
        guard let firstPos = positions.first else {
            return []
        }
        let totalPicksInDraft = draft.settings.numberOfRounds * draft.settings.numberOfTeams
        let pool = draft.playerPool.batters(for: [firstPos], projection: projectionType, draft: draft)
        let smallerPool = pool.filter {
            guard let adp = $0.adp else {
                return false
            }
            return adp <= Double(totalPicksInDraft)
        }
        return smallerPool.sortedByADP
    }

    /// Getting the zScore for the player and then multiplying by projected points
    func wPointsZScore(draft: Draft) -> Double {
        let zscore = zScore(draft: draft)
        let points = fantasyPoints(draft.settings.scoringSystem)

        return zscore * points
    }

    /// (Deprecated) Weighting fantasy points without using zScore
    func weightedFantasyPoints(dict: [Position: Double]) -> Double {
        guard let firstPos = positions.first,
              let average = dict[firstPos]
        else { return 0 }
        return (fantasyPoints(MainModel.shared.getScoringSettings()) / average * fantasyPoints(MainModel.shared.getScoringSettings())).roundTo(places: 1)
    }

    /// (Deprecated) Weighting fantasy points without using zScore
    func weightedFantasyPoints(draft: Draft, limit: Int = 50) -> Double {
        let average = averageForPosition(limit: limit, draft: draft)
        guard average != 0 else { return 0 }

//        let players = draft.playerPool.storedBatters.batters(for: self.projectionType, at: firstPos).prefixArray(limit)
//        let sum = players.reduce(Double(0), {$0 + $1.fantasyPoints(draft.settings.scoringSystem)})
//        let average = sum / Double(players.count)
//        let average = draft.playerPool.storedBatters.average(for: self.projectionType, at: firstPos)
        let points = fantasyPoints(draft.settings.scoringSystem)

        return (points / average * points).roundTo(places: 1)
    }

    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double {
        var points: Double = 0
        points += Double(hr) * scoringSettings.hr
        points += Double(r) * scoringSettings.r
        points += Double(rbi) * scoringSettings.rbi
        points += Double(sb) * scoringSettings.sb

        return points
    }

    static func averagePoints(forThese batters: [ParsedBatter], scoring: ScoringSettings) -> Double {
        guard !batters.isEmpty else { return 0 }
        return (batters.reduce(Double(0)) { $0 + $1.fantasyPoints(scoring) } / Double(batters.count)).roundTo(places: 1)
    }

    func has(position: Position) -> Bool {
        positions.contains(position)
    }
}

// MARK: Initializers

extension ParsedBatter {
//    init(from jsonBatter: JSONBatter, pos: Position, projectionType: ProjectionTypes) {
//        self.empty = jsonBatter.empty
//        self.name = jsonBatter.name
//        self.team = jsonBatter.team
//
//        self.g = Int(jsonBatter.g) ?? 0
//        self.ab = Int(jsonBatter.ab) ?? 0
//        self.pa = Int(jsonBatter.pa) ?? 0
//        self.h = Int(jsonBatter.h) ?? 0
//        self.the1B = Int(jsonBatter.the1B) ?? 0
//        self.the2B = Int(jsonBatter.the2B) ?? 0
//        self.the3B = Int(jsonBatter.the3B) ?? 0
//        self.hr = Int(jsonBatter.hr) ?? 0
//        self.r = Int(jsonBatter.r) ?? 0
//        self.rbi = Int(jsonBatter.rbi) ?? 0
//        self.bb = Int(jsonBatter.bb) ?? 0
//        self.ibb = Int(jsonBatter.ibb) ?? 0
//        self.so = Int(jsonBatter.so) ?? 0
//        self.hbp = Int(jsonBatter.hbp) ?? 0
//        self.sf = Int(jsonBatter.sf) ?? 0
//        self.sh = Int(jsonBatter.sh) ?? 0
//        self.sb = Int(jsonBatter.sb) ?? 0
//        self.cs = Int(jsonBatter.cs) ?? 0
//
//        self.avg = Double("0" + jsonBatter.avg) ?? 0
//
//        self.positions = [pos]
//
//        self.projectionType = projectionType
//        self.adp = 91281
//    }

    init(from jsonBatter: ExtendedBatter, pos: Position, projectionType: ProjectionTypes) {
        self.empty = ""
        self.name = jsonBatter.playerName ?? "NA"
        self.team = jsonBatter.team ?? "NA"
        self.g = Int(jsonBatter.g ?? -99)
        self.ab = Int(jsonBatter.ab ?? -99)
        self.pa = Int(jsonBatter.pa ?? -99)
        self.h = Int(jsonBatter.h ?? -99)
        self.the1B = Int(jsonBatter.the1B ?? -99)
        self.the2B = Int(jsonBatter.the2B ?? -99)
        self.the3B = Int(jsonBatter.the3B ?? -99)
        self.hr = Int(jsonBatter.hr ?? -99)
        self.r = Int(jsonBatter.r ?? -99)
        self.rbi = Int(jsonBatter.rbi ?? -99)
        self.bb = Int(jsonBatter.bb ?? -99)
        self.ibb = Int(jsonBatter.ibb ?? -99)
        self.so = Int(jsonBatter.so ?? -99)
        self.hbp = Int(jsonBatter.hbp ?? -99)
        self.sf = Int(jsonBatter.sf ?? -99)
        self.sh = Int(jsonBatter.sh ?? -99)
        self.sb = Int(jsonBatter.sb ?? -99)
        self.cs = Int(jsonBatter.cs ?? -99)

        self.avg = Double("0" + (jsonBatter.avg?.str ?? "")) ?? 0

        self.positions = [pos]

        self.projectionType = projectionType
        self.adp = jsonBatter.adp
        if adp == nil {
            print("\(name) for \(projectionType) has no ADP")
        }
    }

    // MARK: Codable initializer

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.empty = try container.decode(String.self, forKey: .empty)
        self.name = try container.decode(String.self, forKey: .name)
        self.team = try container.decode(String.self, forKey: .team)
        self.g = try container.decode(Int.self, forKey: .g)
        self.ab = try container.decode(Int.self, forKey: .ab)
        self.pa = try container.decode(Int.self, forKey: .pa)
        self.h = try container.decode(Int.self, forKey: .h)
        self.the1B = try container.decode(Int.self, forKey: .the1B)
        self.the2B = try container.decode(Int.self, forKey: .the2B)
        self.the3B = try container.decode(Int.self, forKey: .the3B)
        self.hr = try container.decode(Int.self, forKey: .hr)
        self.r = try container.decode(Int.self, forKey: .r)
        self.rbi = try container.decode(Int.self, forKey: .rbi)
        self.bb = try container.decode(Int.self, forKey: .bb)
        self.ibb = try container.decode(Int.self, forKey: .ibb)
        self.so = try container.decode(Int.self, forKey: .so)
        self.hbp = try container.decode(Int.self, forKey: .hbp)
        self.sf = try container.decode(Int.self, forKey: .sf)
        self.sh = try container.decode(Int.self, forKey: .sh)
        self.sb = try container.decode(Int.self, forKey: .sb)
        self.cs = try container.decode(Int.self, forKey: .cs)
        self.avg = try container.decode(Double.self, forKey: .avg)
        self.positions = try container.decode([Position].self, forKey: .positions)
        self.projectionType = try container.decode(ProjectionTypes.self, forKey: .projectionType)
        self.adp = try container.decodeIfPresent(Double.self, forKey: .adp)
    }
}

// MARK: - Functions

extension ParsedBatter {
    func similarPlayers(_ numberOfPlayers: Int, for position: Position, and projection: ProjectionTypes) -> [ParsedBatter] {
        let preSortedBatters = AllExtendedBatters.batters(for: projection, at: position, limit: UserDefaults.positionLimit)
        let selfPoints = fantasyPoints(MainModel.shared.scoringSettings)
        let sortedBatters = preSortedBatters.sorted { firstBatter, secondBatter in

            let firstDifference = abs(selfPoints - firstBatter.fantasyPoints(MainModel.shared.scoringSettings))
            let secondDifference = abs(selfPoints - secondBatter.fantasyPoints(MainModel.shared.scoringSettings))

            return firstDifference > secondDifference
        }

        return sortedBatters.prefixArray(numberOfPlayers)
    }
}

// MARK: Codable, Hashable, Equatable

extension ParsedBatter {
    enum CodingKeys: CodingKey {
        case empty, name, team
        case g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs
        case avg, positions, projectionType, adp
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(empty, forKey: .empty)
        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
        try container.encode(g, forKey: .g)
        try container.encode(ab, forKey: .ab)
        try container.encode(pa, forKey: .pa)
        try container.encode(h, forKey: .h)
        try container.encode(the1B, forKey: .the1B)
        try container.encode(the2B, forKey: .the2B)
        try container.encode(the3B, forKey: .the3B)
        try container.encode(hr, forKey: .hr)
        try container.encode(r, forKey: .r)
        try container.encode(rbi, forKey: .rbi)
        try container.encode(bb, forKey: .bb)
        try container.encode(ibb, forKey: .ibb)
        try container.encode(so, forKey: .so)
        try container.encode(hbp, forKey: .hbp)
        try container.encode(sf, forKey: .sf)
        try container.encode(sh, forKey: .sh)
        try container.encode(sb, forKey: .sb)
        try container.encode(cs, forKey: .cs)
        try container.encode(avg, forKey: .avg)
        try container.encode(positions, forKey: .positions)
        try container.encode(projectionType, forKey: .projectionType)
        try container.encode(adp, forKey: .adp)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.removingWhiteSpaces())
        hasher.combine(team.removingWhiteSpaces())
        hasher.combine(projectionType)
        hasher.combine(sb)
        hasher.combine(rbi)
        hasher.combine(avg)
    }

    static func == (lhs: ParsedBatter, rhs: ParsedBatter) -> Bool {
        return
            lhs.name.removingWhiteSpaces() == rhs.name.removingWhiteSpaces() &&
            lhs.team.removingWhiteSpaces() == rhs.team.removingWhiteSpaces()
    }
}

// MARK: - ParsedPitcher

struct ParsedPitcher: CustomStringConvertible, Codable, Hashable, ParsedPlayer {
    var starHasBeenSetAtLeastOnce: Bool = false

    var isStarred: Bool = false

    func samePlayer(for projection: ProjectionTypes) -> ParsedPlayer? {
        let allPlayers: [ParsedPitcher]
        switch projection {
            case .steamer:
                allPlayers = AllExtendedPitchers.steamer.all
            case .thebat:
                allPlayers = AllExtendedPitchers.theBat.all
            case .atc:
                allPlayers = AllExtendedPitchers.atc.all
            case .depthCharts:
                allPlayers = AllExtendedPitchers.depthCharts.all
            case .myProjections, .thebatx, .zips:
                allPlayers = []
        }

        return allPlayers.first(where: { $0.name == self.name && $0.team == self.team })
    }

    func averageForPosition(limit: Int, draft: Draft) -> Double {
        let allPlayers = draft.playerPool.storedPitchers.pitchers(for: projectionType, at: type, scoring: draft.settings.scoringSystem)
        let sorted = allPlayers.sortedByPoints(scoring: draft.settings.scoringSystem)
        let top = sorted.prefixArray(limit)
        let sum: Double = top.reduce(0) { partial, element in
            partial + element.fantasyPoints(draft.settings.scoringSystem)
        }
        return sum / Double(top.count)
    }

    var name, team: String
    var w, l, gs, g, sv, hld, ip, tbf, h, r, er, hr, so, bb, ibb, hbp, qs: Int
    var era, fip, war, ra9War: Double
    let playerids: String
    let projectionType: ProjectionTypes
    let type: PitcherType
    let adp: Double?

    var description: String {
        [name, team, projectionType.title, adp?.str ?? "NO ADP"].joined(separator: ", ")
    }

    func posStr() -> String {
        type.short.uppercased()
    }

    func adpStr() -> String? {
        guard let adp = adp else { return nil }
        let rounded = adp.roundTo(places: 1)
        if rounded == Double(Int(rounded)) {
            return Int(rounded).str
        }
        return rounded.str()
    }

//    var k9, bb9, kbb, hr9, kperc, gbperc: String

    let starterStatKeys: [String] = ["GS", "W", "L", "IP", "QS", "H", "R", "ER", "HR", "SO", "BB"]
    let relieverStatKeys: [String] = ["W", "L", "IP", "SV", "HLD", "H", "R", "ER", "HR", "SO", "BB"]

    var dict: [String: Any] {
        ["GS": gs,
         "W": w,
         "L": l,
         "IP": ip,
         "QS": qs,
         "H": h,
         "R": r,
         "ER": er,
         "HR": hr,
         "SO": so,
         "BB": bb,
         "SV": sv,
         "HLD": hld]
    }

    var peers: [ParsedPitcher] {
        AllExtendedPitchers.pitchers(pitcher: self)
    }

    func pitcherRank(scoring: ScoringSettings = .defaultPoints) -> Int? {
        let peers = self.peers
        let sortedPeers = peers.sortedByPoints(scoring: scoring)
        guard let firstIndex = sortedPeers.firstIndex(of: self) else {
            return nil
        }
        return firstIndex + 1
    }

    func fantasyPoints(_ scoring: ScoringSettings) -> Double {
//        print("Getting points for", self.name)
        var sum: Double = 0

        let wins = Double(w) * scoring.wins
        let sv = Double(sv) * scoring.saves
        let er = Double(er) * scoring.earnedRuns
        let k = Double(so) * scoring.pitcherK
        let ip = Double(ip) * scoring.inningsPitched
        let h = Double(h) * scoring.hitsAllowed
        let bb = Double(bb) * scoring.walksAllowed
        let qs = qs > 0 ? Double(qs) * scoring.qualityStarts : 0
        let l = Double(l) * scoring.losses

        sum += wins
        sum += sv
        sum += er
        sum += k
        sum += ip
        sum += h
        sum += bb
        sum += qs
        sum += l

        return sum
    }

    func weightedFantasyPoints(draft: Draft, limit: Int = 100) -> Double {
        let otherPlayers = draft.playerPool.storedPitchers.pitchers(for: projectionType, at: type, scoring: draft.settings.scoringSystem).prefixArray(limit)
//        print("Position: \(player.type.str)")
//        for otherPlayer in otherPlayers {
//            print(otherPlayer.name, "\(otherPlayer.fantasyPoints(model.draft.settings.scoringSystem))")
//        }
        let average = ParsedPitcher.averagePoints(forThese: otherPlayers, scoringSettings: draft.settings.scoringSystem)
        guard average != 0 else { return 0 }
//        let average = draft.playerPool.storedBatters.average(for: self.projectionType, at: firstPos)
        let points = fantasyPoints(draft.settings.scoringSystem)

        return (points / average * points).roundTo(places: 1)
    }

    static func averagePoints(forThese pitchers: [ParsedPitcher], scoringSettings: ScoringSettings) -> Double {
        guard !pitchers.isEmpty else { return 0 }
        return (pitchers.reduce(Double(0)) { $0 + $1.fantasyPoints(scoringSettings) } / Double(pitchers.count)).roundTo(places: 1)
    }

    func zScore(draft: Draft, limit: Int = 40) -> Double {
//        print(player.name, "points", self.fantasyPoints(draft.settings.scoringSystem).str())
        let otherPlayers = draft.playerPool.storedPitchers.pitchers(for: projectionType, at: type, scoring: draft.settings.scoringSystem).prefixArray(limit)
//        print("Position: \(player.type.str)")
//        for otherPlayer in otherPlayers {
//            print(otherPlayer.name, "\(otherPlayer.fantasyPoints(model.draft.settings.scoringSystem))")
//        }
        let average = ParsedPitcher.averagePoints(forThese: otherPlayers, scoringSettings: draft.settings.scoringSystem)
//        print("average for this position: ", average.str())
        let stdDev = otherPlayers.standardDeviation(scoring: draft.settings.scoringSystem)
//        print("std: ", stdDev.str())

        let zScore = (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev
//        print("Z score", zScore.str())

        return zScore
//        let average = draft.playerPool.storedPitchers.average(for: self.projectionType, at: self.type)
//        let stdDev = draft.playerPool.storedPitchers.stdDev(for: self.projectionType, type: self.type)
//        return (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev
    }

    func peers(draft: Draft) -> [ParsedPitcher] {
        let totalPicksInDraft = draft.settings.numberOfRounds * draft.settings.numberOfTeams
        let pool = draft.playerPool.storedPitchers.pitchers(for: projectionType, at: type)
        let smallerPool = pool.filter {
            guard let adp = $0.adp else { return false }
            return adp <= Double(totalPicksInDraft)
        }
        return smallerPool.sortedByADP
    }

    /// Limit ADP
    func zScore(draft: Draft) -> Double {
        let smallerPool: [ParsedPitcher] = peers(draft: draft)

        let average = ParsedPitcher.averagePoints(forThese: smallerPool, scoringSettings: draft.settings.scoringSystem)
        let stdDev = smallerPool.standardDeviation(scoring: draft.settings.scoringSystem)

        let zScore = (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev

        return zScore
    }

    func wPointsZScore(draft: Draft) -> Double {
        let zscore = zScore(draft: draft)
        let points = fantasyPoints(draft.settings.scoringSystem)

        return zscore * points
    }

    var id: String { name + team }

    init(from jsonPitcher: ExtendedPitcher, type: PitcherType, projection: ProjectionTypes) {
        self.name = jsonPitcher.playerName ?? "NA"
        self.team = jsonPitcher.team ?? "NA"
        self.w = Int(jsonPitcher.w ?? -99)
        self.l = Int(jsonPitcher.l ?? -99)
        self.gs = Int(jsonPitcher.gs ?? -99)
        self.g = Int(jsonPitcher.g ?? -99)
        self.sv = Int(jsonPitcher.sv ?? -99)
        self.hld = Int(jsonPitcher.hld ?? -99)
        self.ip = Int(jsonPitcher.ip ?? -99)
        self.tbf = Int(jsonPitcher.tbf ?? -99)
        self.h = Int(jsonPitcher.h ?? -99)
        self.r = Int(jsonPitcher.r ?? -99)
        self.er = Int(jsonPitcher.er ?? -99)
        self.hr = Int(jsonPitcher.hr ?? -99)
        self.so = Int(jsonPitcher.so ?? -99)
        self.bb = Int(jsonPitcher.bb ?? -99)
        self.ibb = Int(jsonPitcher.ibb ?? -99)
        self.hbp = Int(jsonPitcher.hbp ?? -99)
        self.qs = Int(jsonPitcher.qs ?? -99)
        self.playerids = jsonPitcher.playerids ?? "NA"
        self.era = Double(jsonPitcher.era ?? -99)
        self.fip = Double(jsonPitcher.fip ?? -99)
        self.war = Double(jsonPitcher.war ?? -99)
        self.ra9War = Double(jsonPitcher.ra9War ?? -99)
        self.adp = jsonPitcher.adp
        self.projectionType = projection
        self.type = type
    }
}

// MARK: - PitcherType

enum PitcherType: String, Codable, Hashable, Identifiable, CustomStringConvertible, Equatable {
    case starter, reliever

    var short: String {
        switch self {
            case .starter:
                return "SP"
            case .reliever:
                return "RP"
        }
    }

    var str: String { rawValue }
    var description: String { rawValue }
    var id: String { rawValue }
}

// MARK: - Codable

extension ParsedPitcher {
    enum CodingKeys: String, CodingKey {
        case name, team, w, l, gs, g, sv, hld, ip, tbf, h, r, er, hr, so, bb, ibb, hbp, qs, era, fip, war, ra9War, adp, playerids, projectionType, type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.team = try container.decode(String.self, forKey: .team)
        self.w = try container.decode(Int.self, forKey: .w)
        self.l = try container.decode(Int.self, forKey: .l)
        self.gs = try container.decode(Int.self, forKey: .gs)
        self.g = try container.decode(Int.self, forKey: .g)
        self.sv = try container.decode(Int.self, forKey: .sv)
        self.hld = try container.decode(Int.self, forKey: .hld)
        self.ip = try container.decode(Int.self, forKey: .ip)
        self.tbf = try container.decode(Int.self, forKey: .tbf)
        self.h = try container.decode(Int.self, forKey: .h)
        self.r = try container.decode(Int.self, forKey: .r)
        self.er = try container.decode(Int.self, forKey: .er)
        self.hr = try container.decode(Int.self, forKey: .hr)
        self.so = try container.decode(Int.self, forKey: .so)
        self.bb = try container.decode(Int.self, forKey: .bb)
        self.ibb = try container.decode(Int.self, forKey: .ibb)
        self.hbp = try container.decode(Int.self, forKey: .hbp)
        self.qs = try container.decode(Int.self, forKey: .qs)
        self.era = try container.decode(Double.self, forKey: .era)
        self.fip = try container.decode(Double.self, forKey: .fip)
        self.war = try container.decode(Double.self, forKey: .war)
        self.ra9War = try container.decode(Double.self, forKey: .ra9War)
        self.adp = try container.decode(Double.self, forKey: .adp)
        self.playerids = try container.decode(String.self, forKey: .playerids)
        self.projectionType = try container.decode(ProjectionTypes.self, forKey: .projectionType)
        self.type = try container.decode(PitcherType.self, forKey: .type)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
        try container.encode(w, forKey: .w)
        try container.encode(l, forKey: .l)
        try container.encode(gs, forKey: .gs)
        try container.encode(g, forKey: .g)
        try container.encode(sv, forKey: .sv)
        try container.encode(hld, forKey: .hld)
        try container.encode(ip, forKey: .ip)
        try container.encode(tbf, forKey: .tbf)
        try container.encode(h, forKey: .h)
        try container.encode(r, forKey: .r)
        try container.encode(er, forKey: .er)
        try container.encode(hr, forKey: .hr)
        try container.encode(so, forKey: .so)
        try container.encode(bb, forKey: .bb)
        try container.encode(ibb, forKey: .ibb)
        try container.encode(hbp, forKey: .hbp)
        try container.encode(qs, forKey: .qs)
        try container.encode(era, forKey: .era)
        try container.encode(fip, forKey: .fip)
        try container.encode(war, forKey: .war)
        try container.encode(ra9War, forKey: .ra9War)
        try container.encode(adp, forKey: .adp)
        try container.encode(playerids, forKey: .playerids)
        try container.encode(projectionType, forKey: .projectionType)
        try container.encode(type, forKey: .type)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.removingWhiteSpaces())
        hasher.combine(team.removingWhiteSpaces())
        hasher.combine(projectionType)
    }

    static func == (lhs: ParsedPitcher, rhs: ParsedPitcher) -> Bool {
        return
            lhs.name.removingWhiteSpaces() == rhs.name.removingWhiteSpaces() &&
            lhs.team.removingWhiteSpaces() == rhs.team.removingWhiteSpaces()
            && lhs.projectionType == rhs.projectionType
    }
}
