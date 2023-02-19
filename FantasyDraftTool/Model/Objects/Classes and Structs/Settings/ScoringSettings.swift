//
//  ScoringSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/23/23.
//

import Foundation

// MARK: - ScoringSettings

struct ScoringSettings: Codable, Hashable, Equatable {
    // MARK: - Stored Properties

    var tb: Double
    var hr: Double
    var r: Double
    var rbi: Double
    var sb: Double
    var cs: Double
    var bb: Double
    var so: Double
    var wins: Double
    var saves: Double
    var earnedRuns: Double
    var inningsPitched: Double
    var hitsAllowed: Double
    var walksAllowed: Double
    var strikeoutsAllowed: Double
    var qualityStarts: Double
    
    

    // MARK: - Computed Properties

    var dict: [String: Double] {
        [Naming.tb.rawValue: tb,
         Naming.r.rawValue: r,
         Naming.rbi.rawValue: rbi,
         Naming.sb.rawValue: sb,
         Naming.cs.rawValue: cs,
         Naming.bb.rawValue: bb,
         Naming.so.rawValue: so]
    }
    
    var defaultsKey: String {
        var str: String = ""
        for key in dict.keys {
            if let value = dict[str] {
                str += key + "="
                str += value.str
            }
        }
        return str
    }

    // MARK: - Static Properties

    static let defaultPoints = ScoringSettings(tb: 1, hr: 4, r: 1, rbi: 1, sb: 1, cs: -1, bb: 1, so: -1, wins: 5, saves: 3, earnedRuns: -1, inningsPitched: 1, hitsAllowed: -1, walksAllowed: -1, strikeoutsAllowed: 1, qualityStarts: 3)

    // MARK: - Methods

    mutating func changeValue(to newValue: Double, for stat: Naming) {
        switch stat {
            case .tb:
                tb = newValue
            case .r:
                r = newValue
            case .rbi:
                rbi = newValue
            case .sb:
                sb = newValue
            case .cs:
                cs = newValue
            case .bb:
                bb = newValue
            case .so:
                so = newValue
            default:
                break
        }
    }

    // MARK: Calculations

    func fantasyPoints(for batter: Batter) -> Double {
        var points: Double = 0
        points += batter.totalBases * tb
        points += Double(batter.r) * r
        points += Double(batter.rbi) * rbi
        points += Double(batter.sb) * sb
        points += Double(batter.cs) * cs
        points += Double(batter.bb) * bb
        points += Double(batter.so) * so
        return points
    }

    func fantasyPoints(for stat: Statistic, for batter: Batter) -> Double {
        switch stat {
            case .tb:
                return batter.totalBases * tb
            case .singles:
                return Double(batter.singles)
            case .doubles:
                return Double(batter.doubles) * 2
            case .triples:
                return Double(batter.triples) * 3
            case .hr:
                return Double(batter.hr) * 4
            case .r:
                return Double(batter.r) * r
            case .rbi:
                return Double(batter.rbi) * rbi
            case .sb:
                return Double(batter.sb) * sb
            case .cs:
                return Double(batter.cs) * cs
            case .bb:
                return Double(batter.bb) * bb
            case .so:
                return Double(batter.so) * so
        }
    }
}

// MARK: - Codable, Hashable, Equatable

extension ScoringSettings {

    enum CodingKeys: String, CodingKey {
        case tb
        case hr
        case r
        case rbi
        case sb
        case cs
        case bb
        case so
        case wins
        case saves
        case earnedRuns
        case inningsPitched
        case hitsAllowed
        case walksAllowed
        case strikeoutsAllowed
        case qualityStarts
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tb = try container.decode(Double.self, forKey: .tb)
        self.hr = try container.decode(Double.self, forKey: .hr)
        self.r = try container.decode(Double.self, forKey: .r)
        self.rbi = try container.decode(Double.self, forKey: .rbi)
        self.sb = try container.decode(Double.self, forKey: .sb)
        self.cs = try container.decode(Double.self, forKey: .cs)
        self.bb = try container.decode(Double.self, forKey: .bb)
        self.so = try container.decode(Double.self, forKey: .so)
        self.wins = try container.decode(Double.self, forKey: .wins)
        self.saves = try container.decode(Double.self, forKey: .saves)
        self.earnedRuns = try container.decode(Double.self, forKey: .earnedRuns)
        self.inningsPitched = try container.decode(Double.self, forKey: .inningsPitched)
        self.hitsAllowed = try container.decode(Double.self, forKey: .hitsAllowed)
        self.walksAllowed = try container.decode(Double.self, forKey: .walksAllowed)
        self.strikeoutsAllowed = try container.decode(Double.self, forKey: .strikeoutsAllowed)
        self.qualityStarts = try container.decode(Double.self, forKey: .qualityStarts)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tb, forKey: .tb)
        try container.encode(hr, forKey: .hr)
        try container.encode(r, forKey: .r)
        try container.encode(rbi, forKey: .rbi)
        try container.encode(sb, forKey: .sb)
        try container.encode(cs, forKey: .cs)
        try container.encode(bb, forKey: .bb)
        try container.encode(so, forKey: .so)
        try container.encode(wins, forKey: .wins)
        try container.encode(saves, forKey: .saves)
        try container.encode(earnedRuns, forKey: .earnedRuns)
        try container.encode(inningsPitched, forKey: .inningsPitched)
        try container.encode(hitsAllowed, forKey: .hitsAllowed)
        try container.encode(walksAllowed, forKey: .walksAllowed)
        try container.encode(strikeoutsAllowed, forKey: .strikeoutsAllowed)
        try container.encode(qualityStarts, forKey: .qualityStarts)
    }

    static func == (lhs: ScoringSettings, rhs: ScoringSettings) -> Bool {
        return lhs.tb == rhs.tb &&
            lhs.hr == rhs.hr &&
            lhs.r == rhs.r &&
            lhs.rbi == rhs.rbi &&
            lhs.sb == rhs.sb &&
            lhs.cs == rhs.cs &&
            lhs.bb == rhs.bb &&
            lhs.so == rhs.so &&
            lhs.wins == rhs.wins &&
            lhs.saves == rhs.saves &&
            lhs.earnedRuns == rhs.earnedRuns &&
            lhs.inningsPitched == rhs.inningsPitched &&
            lhs.hitsAllowed == rhs.hitsAllowed &&
            lhs.walksAllowed == rhs.walksAllowed &&
            lhs.strikeoutsAllowed == rhs.strikeoutsAllowed &&
            lhs.qualityStarts == rhs.qualityStarts
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tb)
        hasher.combine(hr)
        hasher.combine(r)
        hasher.combine(rbi)
        hasher.combine(sb)
        hasher.combine(cs)
        hasher.combine(bb)
        hasher.combine(so)
        hasher.combine(wins)
        hasher.combine(saves)
        hasher.combine(earnedRuns)
        hasher.combine(inningsPitched)
        hasher.combine(hitsAllowed)
        hasher.combine(walksAllowed)
        hasher.combine(strikeoutsAllowed)
        hasher.combine(qualityStarts)
    }

}

extension ScoringSettings {
    enum Statistic: CaseIterable {
        case tb
        case singles
        case doubles
        case triples
        case hr
        case r
        case rbi
        case sb
        case cs
        case bb
        case so
    }
}
