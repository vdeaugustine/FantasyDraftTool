//
//  ParsedPitcher.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/25/23.
//

import Foundation

// MARK: - ParsedPitcher

struct ParsedPitcher: CustomStringConvertible, Codable, Hashable, ParsedPlayer {
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
         "H": h ,
         "R": r ,
         "ER": er ,
         "HR": hr ,
         "SO": so ,
         "BB": bb ,
         "SV": sv ,
         "HLD": hld ]
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

enum PitcherType: String, Codable, Hashable, Identifiable, CustomStringConvertible {
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
