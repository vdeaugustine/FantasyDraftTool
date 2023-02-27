//
//  AverageStats.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - AverageStats

enum AverageStats: String, Hashable, Identifiable {
    case g, ab, pa, tb, r, rbi, so, bb, singles, doubles, triples, hr, h, hbp, sb, cs

    static let arr: [AverageStats] = [.g, .ab, .pa, .tb, .r, .rbi, .so, .bb]

    var str: String { rawValue.uppercased() }

    var id: String { str }

    static func average(stat: AverageStats, for position: Position, projectionType: ProjectionTypes) -> Double {
        let batters = AllExtendedBatters.batters(for: projectionType, at: position, limit: UserDefaults.positionLimit)
        let sum: Double
        switch stat {
            case .g:
                sum = batters.reduce(Double(0)) { $0 + Double($1.g) }
            case .ab:
                sum = batters.reduce(Double(0)) { $0 + Double($1.ab) }
            case .pa:
                sum = batters.reduce(Double(0)) { $0 + Double($1.pa) }
            case .tb:
                sum = batters.reduce(Double(0)) { $0 + Double($1.tb) }
            case .r:
                sum = batters.reduce(Double(0)) { $0 + Double($1.r) }
            case .rbi:
                sum = batters.reduce(Double(0)) { $0 + Double($1.rbi) }
            case .so:
                sum = batters.reduce(Double(0)) { $0 + Double($1.so) }
            case .bb:
                sum = batters.reduce(Double(0)) { $0 + Double($1.bb) }
            case .singles:
                sum = batters.reduce(Double(0)) { $0 + Double($1.the1B) }
            case .doubles:
                sum = batters.reduce(Double(0)) { $0 + Double($1.the2B) }
            case .triples:
                sum = batters.reduce(Double(0)) { $0 + Double($1.the3B) }
            case .hr:
                sum = batters.reduce(Double(0)) { $0 + Double($1.hr) }
            case .h:
                sum = batters.reduce(Double(0)) { $0 + Double($1.h) }
            case .hbp:
                sum = batters.reduce(Double(0)) { $0 + Double($1.hbp) }
            case .sb:
                sum = batters.reduce(Double(0)) { $0 + Double($1.sb) }
            case .cs:
                sum = batters.reduce(Double(0)) { $0 + Double($1.cs) }
        }
        return sum / Double(batters.count)
    }

    static func average(for stat: String, for position: Position, and projection: ProjectionTypes) -> Double {
        let chosenStat: AverageStats
        switch stat {
            case "G":
                chosenStat = .g
            case "AB":
                chosenStat = .ab
            case "PA":
                chosenStat = .pa
            case "H":
                chosenStat = .h
            case "1B":
                chosenStat = .singles
            case "2B":
                chosenStat = .doubles
            case "3B":
                chosenStat = .triples
            case "R":
                chosenStat = .r
            case "RBI":
                chosenStat = .rbi
            case "BB":
                chosenStat = .bb
            case "SO":
                chosenStat = .so
            case "HBP":
                chosenStat = .hbp
            case "SB":
                chosenStat = .sb
            case "CS":
                chosenStat = .cs
            default:
                return -99_999
        }

        return average(stat: chosenStat, for: position, projectionType: projection)
    }
}
