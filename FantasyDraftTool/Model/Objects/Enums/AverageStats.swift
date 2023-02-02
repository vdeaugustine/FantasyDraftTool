//
//  AverageStats.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - AverageStats

enum AverageStats: String, Hashable, Identifiable {
    case g, ab, pa, tb, r, rbi, so, bb

    static let arr: [AverageStats] = [.g, .ab, .pa, .tb, .r, .rbi, .so, .bb]

    var str: String { rawValue.uppercased() }

    var id: String { str }

    static func average(stat: AverageStats, for position: Position, projectionType: ProjectionTypes) -> Double {
        let batters = AllParsedBatters.batters(for: projectionType, at: position)
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
        }
        return sum / Double(batters.count)
    }
}
