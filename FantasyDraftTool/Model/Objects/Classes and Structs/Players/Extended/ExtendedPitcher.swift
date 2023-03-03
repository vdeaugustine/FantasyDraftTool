//
//  ExtendedPitcher.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/25/23.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extendedPitcher = try? JSONDecoder().decode(ExtendedPitcher.self, from: jsonData)

import Foundation

// MARK: - ExtendedPitcher

struct ExtendedPitcher: Codable, Hashable, Equatable, CustomStringConvertible {
    let name, team, shortName: String?
    let w, l: Int?
    let era: Double?
    let gs, g, sv, hld: Int?
    let ip, tbf, h, r: Int?
    let er, hr, so, bb: Int?
    let ibb, hbp: Int?
    let whip: Double?
    let k9, bb9, kbb, hr9: String?
    let kperc, bBperc, kBBperc, gBperc: String?
    let avg, babip: Double?
    let loBperc: String?
    let fip, war, ra9War, interSD: Double?
    let interSK, intraSD: Double?
    let qs: Int?
    let adp: Double?
    let teamid: Int?
    let league, playerName, playerids: String?

    var description: String {
        playerName ?? "NO NAME ERROR"
    }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case team = "Team"
        case shortName = "ShortName"
        case w = "W"
        case l = "L"
        case era = "ERA"
        case gs = "GS"
        case g = "G"
        case sv = "SV"
        case hld = "HLD"
        case ip = "IP"
        case tbf = "TBF"
        case h = "H"
        case r = "R"
        case er = "ER"
        case hr = "HR"
        case so = "SO"
        case bb = "BB"
        case ibb = "IBB"
        case hbp = "HBP"
        case whip = "WHIP"
        case k9 = "K9"
        case bb9 = "BB9"
        case kbb = "KBB"
        case hr9 = "HR9"
        case kperc = "Kperc"
        case bBperc = "BBperc"
        case kBBperc = "K-BBperc"
        case gBperc = "GBperc"
        case avg = "AVG"
        case babip = "BABIP"
        case loBperc = "LOBperc"
        case fip = "FIP"
        case war = "WAR"
        case ra9War = "RA9-WAR"
        case interSD = "InterSD"
        case interSK = "InterSK"
        case intraSD = "IntraSD"
        case qs = "QS"
        case adp = "ADP"
        case teamid
        case league = "League"
        case playerName = "PlayerName"
        case playerids
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.team == rhs.team
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(ip)
        hasher.combine(bb)
        hasher.combine(r)
        hasher.combine(so)
    }
}

// MARK: - AllExtendedPitchers

struct AllExtendedPitchers: Codable {
    static let steamer: ExtensionPitcherProjection = .init(projectionType: .steamer)
    static let atc: ExtensionPitcherProjection = .init(projectionType: .atc)
    static let theBat: ExtensionPitcherProjection = .init(projectionType: .thebat)
    static let depthCharts: ExtensionPitcherProjection = .init(projectionType: .depthCharts)
    
    static func starters(for projection: ProjectionTypes, limit: Int) -> [ParsedPitcher] {
        switch projection {
        case .steamer:
            return Self.steamer.starters.prefixArray(limit)
        case .thebat:
            return Self.theBat.starters.prefixArray(limit)
        case .atc:
            return Self.atc.starters.prefixArray(limit)
        case .depthCharts:
            return Self.depthCharts.starters.prefixArray(limit)
        default:
            return []
        }
    }
    
    static func relievers(for projection: ProjectionTypes, limit: Int) -> [ParsedPitcher] {
        switch projection {
        case .steamer:
            return Self.steamer.relievers
        case .thebat:
            return Self.theBat.relievers
        case .atc:
            return Self.atc.relievers
        case .depthCharts:
            return Self.depthCharts.relievers
        default:
            return []
        }
    }
    
}

// MARK: - ExtensionPitcherProjection

struct ExtensionPitcherProjection {
    let starters, relievers: [ParsedPitcher]
    var all: [ParsedPitcher] { starters + relievers }

    init(projectionType: ProjectionTypes) {
        self.starters = Self.loadPitchers(projectionType.extendedFileName(pitcherType: .starter)).map { ParsedPitcher(from: $0, type: .starter, projection: projectionType) }
        self.relievers = Self.loadPitchers(projectionType.extendedFileName(pitcherType: .reliever)).map { ParsedPitcher(from: $0, type: .reliever, projection: projectionType) }
    }

    static func loadPitchers(_ filename: String) -> [ExtendedPitcher] {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: ".json")
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            let arr = try decoder.decode([ExtendedPitcher].self, from: data)
            return Array(Set<ExtendedPitcher>(arr))
        } catch {
            fatalError("Couldn't parse \(filename) as \(ExtendedBatter.self):\n\(error)")
        }
    }
}
