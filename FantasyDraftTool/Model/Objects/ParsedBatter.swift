//
//  ParsedBatter.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import Foundation

// MARK: - ParsedBatter

struct ParsedBatter: Hashable {
    var empty, name, team: String
    var g, ab, pa, h, the1B, the2B, the3B, hr, r, rbi, bb, ibb, so, hbp, sf, sh, sb, cs: Int
    var avg: Double

    var posStr: String {
        positions.reduce("") { $0 + ", " + $1.str.uppercased() }
    }

    var positions: [Positions] {
        var posArr: [Positions] = []
        if !AllParsedBatters.steamer.c.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.c)
        }
        if !AllParsedBatters.steamer.firstBase.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.first)
        }
        if !AllParsedBatters.steamer.secondBase.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.second)
        }
        if !AllParsedBatters.steamer.thirdBase.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.third)
        }
        if !AllParsedBatters.steamer.ss.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.ss)
        }
        if !AllParsedBatters.steamer.of.filter({ $0.name == self.name }).isEmpty {
            posArr.append(.of)
        }

        return posArr
    }

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

    init(from jsonBatter: JSONBatter) {
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
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.ab == rhs.ab &&
            lhs.pa == rhs.pa &&
            lhs.h == rhs.h &&
            lhs.sf == rhs.sf &&
            lhs.r == rhs.r
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(ab)
        hasher.combine(pa)
        hasher.combine(h)
        hasher.combine(sf)
        hasher.combine(r)
        hasher.combine(team)
        hasher.combine(ab)
    }

    func positionWeight(position: Positions, projection: ProjectionTypes, scoringSystem: ScoringSettings = .defaultPoints) -> Double {
        let peersForPosition = AllParsedBatters.batters(for: projection)
        let positionAveragePoints = ParsedBatter.averagePoints(forThese: peersForPosition)
        return (fantasyPoints(scoringSystem) / positionAveragePoints)
    }

    func positionWeightedPoints(position: Positions, projection: ProjectionTypes, scoringSystem: ScoringSettings = .defaultPoints) -> Double {
        positionWeight(position: position, projection: projection, scoringSystem: scoringSystem) * fantasyPoints(scoringSystem)
    }

    func positionWithWeakestPeers(projection: ProjectionTypes) -> Positions? {
        guard let firstPosition = positions.first else {
            return nil
        }
        var lowestWeightPosition: Positions = firstPosition
        var lowestWeight = positionWeight(position: lowestWeightPosition, projection: projection)
        for position in positions {
            let thisWeight = positionWeight(position: position, projection: projection)
            if thisWeight < lowestWeight {
                lowestWeight = thisWeight
                lowestWeightPosition = position
            }
        }
        return lowestWeightPosition
    }

    func weightedPointsForWeakestPosition(projection: ProjectionTypes) -> Double? {
        guard let weakestPosition = positionWithWeakestPeers(projection: projection) else {
            return nil
        }

        return fantasyPoints(.defaultPoints) * positionWeight(position: weakestPosition, projection: projection)
    }
}

extension ParsedBatter {
    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double {
        var points: Double = 0
        points += Double(hr) * scoringSettings.hr
        points += Double(r) * scoringSettings.r
        points += Double(rbi) * scoringSettings.rbi
        points += Double(sb) * scoringSettings.sb

        return points
    }

    static func averagePoints(forThese batters: [ParsedBatter]) -> Double {
        (batters.reduce(Double(0)) { $0 + $1.fantasyPoints(ScoringSettings.defaultPoints) } / Double(batters.count)).roundTo(places: 1)
    }
}
