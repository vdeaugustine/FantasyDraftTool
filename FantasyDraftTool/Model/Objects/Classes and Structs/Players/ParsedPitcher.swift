//
//  ParsedPitcher.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/25/23.
//

import Foundation

// MARK: - ParsedPitcher

struct ParsedPitcher: CustomStringConvertible, Codable, Hashable, ParsedPlayer {
    var name, team: String
    var w, l, gs, g, sv, hld, ip, tbf, h, r, er, hr, so, bb, ibb, hbp, qs: Int
    var era, fip, war, ra9War, adp: Double
    let playerids: String
    let projectionType: ProjectionTypes
    let type: PitcherType

    var description: String {
        [name, team, projectionType.title].joined(separator: ", ")
    }
//    var k9, bb9, kbb, hr9, kperc, gbperc: String
    
    func fantasyPoints(_ scoring: ScoringSettings) -> Double {
        var sum: Double = 0
        
        sum += Double(w) * scoring.wins
        sum += Double(sv) * scoring.saves
        sum += Double(er) * scoring.earnedRuns
        sum += Double(so) * scoring.pitcherK
        sum += Double(ip) * scoring.inningsPitched
        sum += Double(h) * scoring.hitsAllowed
        sum += Double(bb) * scoring.walksAllowed
        sum += Double(qs) * scoring.qualityStarts
        sum += Double(l) * scoring.losses
        
        return sum
        
        
    }
    
    static func averagePoints(forThese pitchers: [ParsedPitcher]) -> Double {
        guard !pitchers.isEmpty else { return 0 }
        return (pitchers.reduce(Double(0)) { $0 + $1.fantasyPoints(ScoringSettings.defaultPoints) } / Double(pitchers.count)).roundTo(places: 1)
    }
    
    func zScore(draft: Draft) -> Double {

        let average = draft.playerPool.storedPitchers.average(for: self.projectionType, at: self.type)
        let stdDev = draft.playerPool.storedPitchers.stdDev(for: self.projectionType, type: self.type)
        return (fantasyPoints(draft.settings.scoringSystem) - average) / stdDev

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
//        k9 = Double(jsonPitcher.k9 ?? -99)
//        bb9 = Double(jsonPitcher.bb9 ?? -99)
//        kbb = Double(jsonPitcher.kbb ?? -99)
//        hr9 = Double(jsonPitcher.hr9 ?? -99)
//        kperc = Double(jsonPitcher.kperc ?? -99)
//        gbperc = Double(jsonPitcher.gBperc ?? -99)
        self.fip = Double(jsonPitcher.fip ?? -99)
        self.war = Double(jsonPitcher.war ?? -99)
        self.ra9War = Double(jsonPitcher.ra9War ?? -99)
        self.adp = Double(jsonPitcher.adp ?? -99)
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
