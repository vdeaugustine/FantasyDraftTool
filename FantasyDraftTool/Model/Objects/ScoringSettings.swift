//
//  ScoringSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/23/23.
//

import Foundation

// MARK: - ScoringSettings

struct ScoringSettings {
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

    var dict: [String: Double] {
        [Naming.tb.rawValue: tb,
         Naming.r.rawValue: r,
         Naming.rbi.rawValue: rbi,
         Naming.sb.rawValue: sb,
         Naming.cs.rawValue: cs,
         Naming.bb.rawValue: bb,
         Naming.so.rawValue: so]
    }
    
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

extension ScoringSettings {
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

extension ScoringSettings {
    static let defaultPoints = ScoringSettings(tb: 1, hr: 4, r: 1, rbi: 1, sb: 1, cs: -1, bb: 1, so: -1, wins: 5, saves: 3, earnedRuns: -1, inningsPitched: 1, hitsAllowed: -1, walksAllowed: -1, strikeoutsAllowed: 1, qualityStarts: 3)
}
