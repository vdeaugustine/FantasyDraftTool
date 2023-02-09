//
//  ParsedBatter.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import Foundation

// MARK: - ParsedBatter

struct ParsedBatter: Hashable, Codable, Identifiable {
    // MARK: Stored Properties

    var empty, name, team: String
    var g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs: Int
    var avg: Double
    let positions: [Position]
    

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
         "SS",
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
    static let nullBatter: ParsedBatter = .init(empty: "", name: "", team: "", g: 0, ab: 0, pa: 0, h: 0, the1B: 0, the2B: 0, the3B: 0, hr: 0, r: 0, rbi: 0, bb: 0, ibb: 0, so: 0, hbp: 0, sf: 0, sh: 0, sb: 0, cs: 0, avg: 0, positions: [])
    

    // MARK: Methods

    func posStr() -> String {
        var retStr: String = ""
        for position in positions {
            retStr += ", " + position.str.uppercased()
        }
        return retStr.removeExtraneousMarks()
    }

    func weightedFantasyPoints(positionAverage: Double) -> Double {
        fantasyPoints(.defaultPoints) / positionAverage * fantasyPoints(.defaultPoints)
    }
    
    func zScore(positionAverage: Double, standardDeviation: Double) -> Double {
        let zScore = (self.fantasyPoints(.defaultPoints) - positionAverage) / standardDeviation
            return zScore
    }
    
    
    

    func weightedFantasyPoints(dict: [Position: Double]) -> Double {
        guard let firstPos = positions.first,
              let average = dict[firstPos]
        else { return 0 }
        return (fantasyPoints(.defaultPoints) / average * fantasyPoints(.defaultPoints)).roundTo(places: 1)
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
}

// MARK: Initializers

extension ParsedBatter {
    
    init(from jsonBatter: JSONBatter, pos: Position) {
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
    }

    
}



// MARK: - Functions
extension ParsedBatter {
    
}

// MARK: Codable, Hashable, Equatable
extension ParsedBatter {
    enum CodingKeys: CodingKey {
        case empty, name, team
        case g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs
        case avg, positions
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
    }

    func hash(into hasher: inout Hasher) {
//        hasher.combine(empty)
        hasher.combine(name.removingWhiteSpaces())
        hasher.combine(team.removingWhiteSpaces())
//        hasher.combine(g)
//        hasher.combine(ab)
//        hasher.combine(pa)
//        hasher.combine(h)
//        hasher.combine(the1B)
//        hasher.combine(the2B)
//        hasher.combine(the3B)
//        hasher.combine(hr)
//        hasher.combine(r)
//        hasher.combine(rbi)
//        hasher.combine(bb)
//        hasher.combine(ibb)
//        hasher.combine(so)
//        hasher.combine(hbp)
//        hasher.combine(sf)
//        hasher.combine(sh)
//        hasher.combine(sb)
//        hasher.combine(cs)
//        hasher.combine(avg)
//        hasher.combine(positions)
    }

    static func == (lhs: ParsedBatter, rhs: ParsedBatter) -> Bool {
        return
        lhs.name.removingWhiteSpaces() == rhs.name.removingWhiteSpaces() &&
            lhs.team.removingWhiteSpaces() == rhs.team.removingWhiteSpaces() // &&
//            lhs.g == rhs.g &&
//            lhs.ab == rhs.ab &&
//            lhs.pa == rhs.pa &&
//            lhs.h == rhs.h &&
//            lhs.the1B == rhs.the1B &&
//            lhs.the2B == rhs.the2B &&
//            lhs.the3B == rhs.the3B &&
//            lhs.hr == rhs.hr &&
//            lhs.r == rhs.r &&
//            lhs.rbi == rhs.rbi &&
//            lhs.bb == rhs.bb &&
//            lhs.ibb == rhs.ibb &&
//            lhs.so == rhs.so &&
//            lhs.hbp == rhs.hbp &&
//            lhs.sf == rhs.sf &&
//            lhs.sh == rhs.sh &&
//            lhs.sb == rhs.sb &&
//            lhs.cs == rhs.cs &&
//            lhs.avg == rhs.avg
    }
}
