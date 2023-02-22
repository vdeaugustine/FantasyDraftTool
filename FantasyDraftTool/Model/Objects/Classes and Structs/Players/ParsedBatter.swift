//
//  ParsedBatter.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import Foundation

// MARK: - ParsedBatter

struct ParsedBatter: Hashable, Codable, Identifiable, CustomStringConvertible {
    // MARK: Stored Properties

    var empty, name, team: String
    var g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs: Int
    var avg: Double
    let positions: [Position]
    var projectionType: ProjectionTypes

    var description: String {
        name + " \(projectionType.title)"
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

    // MARK: - Static Properties

    static let nullBatter: ParsedBatter = .init(empty: "", name: "", team: "", g: 0, ab: 0, pa: 0, h: 0, the1B: 0, the2B: 0, the3B: 0, hr: 0, r: 0, rbi: 0, bb: 0, ibb: 0, so: 0, hbp: 0, sf: 0, sh: 0, sb: 0, cs: 0, avg: 0, positions: [], projectionType: .steamer)

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

    func zScore(draft: Draft) -> Double {
        guard let firstPost = positions.first,
              let average = draft.playerPool.positionAveragesDict[firstPost],
              let _ = draft.playerPool.battersDict[firstPost],
              let stdDev: Double = draft.playerPool.standardDeviationDict[firstPost]
        else {
            return (0 - .infinity)
        }

        let zScore = (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev

        return zScore
    }

    func weightedFantasyPoints(dict: [Position: Double]) -> Double {
        guard let firstPos = positions.first,
              let average = dict[firstPos]
        else { return 0 }
        return (fantasyPoints(MainModel.shared.getScoringSettings()) / average * fantasyPoints(MainModel.shared.getScoringSettings())).roundTo(places: 1)
    }

    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double {
        var points: Double = 0
        points += Double(hr) * scoringSettings.hr
        points += Double(r) * scoringSettings.r
        points += Double(rbi) * scoringSettings.rbi
        points += Double(sb) * scoringSettings.sb

        return points
    }

    static func averagePoints(forThese batters: [ParsedBatter]) -> Double {
        guard !batters.isEmpty else { return 0 }
        return (batters.reduce(Double(0)) { $0 + $1.fantasyPoints(ScoringSettings.defaultPoints) } / Double(batters.count)).roundTo(places: 1)
    }

    func has(position: Position) -> Bool {
        positions.contains(position)
    }
}

// MARK: Initializers

extension ParsedBatter {
    init(from jsonBatter: JSONBatter, pos: Position, projectionType: ProjectionTypes) {
        self.empty = jsonBatter.empty
        self.name = jsonBatter.name
        self.team = jsonBatter.team

        self.g = Int(jsonBatter.g) ?? 0
        self.ab = Int(jsonBatter.ab) ?? 0
        self.pa = Int(jsonBatter.pa) ?? 0
        self.h = Int(jsonBatter.h) ?? 0
        self.the1B = Int(jsonBatter.the1B) ?? 0
        self.the2B = Int(jsonBatter.the2B) ?? 0
        self.the3B = Int(jsonBatter.the3B) ?? 0
        self.hr = Int(jsonBatter.hr) ?? 0
        self.r = Int(jsonBatter.r) ?? 0
        self.rbi = Int(jsonBatter.rbi) ?? 0
        self.bb = Int(jsonBatter.bb) ?? 0
        self.ibb = Int(jsonBatter.ibb) ?? 0
        self.so = Int(jsonBatter.so) ?? 0
        self.hbp = Int(jsonBatter.hbp) ?? 0
        self.sf = Int(jsonBatter.sf) ?? 0
        self.sh = Int(jsonBatter.sh) ?? 0
        self.sb = Int(jsonBatter.sb) ?? 0
        self.cs = Int(jsonBatter.cs) ?? 0

        self.avg = Double("0" + jsonBatter.avg) ?? 0

        self.positions = [pos]

        self.projectionType = projectionType
    }

    init(from jsonBatter: ExtendedBatter, pos: Position, projectionType: ProjectionTypes) {
        self.empty = jsonBatter.empty ?? "NA"
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
    }
}

// MARK: - Functions

extension ParsedBatter {
    func similarPlayers(_ numberOfPlayers: Int, for position: Position, and projection: ProjectionTypes) -> [ParsedBatter] {
        let preSortedBatters = AllExtendedBatters.batters(for: projection, at: position).sortedByPoints
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
        case avg, positions, projectionType
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
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.removingWhiteSpaces())
        hasher.combine(team.removingWhiteSpaces())
        hasher.combine(projectionType)
    }

    static func == (lhs: ParsedBatter, rhs: ParsedBatter) -> Bool {
        return
            lhs.name.removingWhiteSpaces() == rhs.name.removingWhiteSpaces() &&
            lhs.team.removingWhiteSpaces() == rhs.team.removingWhiteSpaces()
        && lhs.projectionType == rhs.projectionType
    }
}
