//
//  ExtendedBatter.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/18/23.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extendedBatter = try? JSONDecoder().decode(ExtendedBatter.self, from: jsonData)

import Foundation

// MARK: - ExtendedBatter

struct ExtendedBatter: Codable, Hashable, Equatable, CustomStringConvertible {
    let name: String
    let team, shortName: String?
    let g, ab, pa, h: Int
    let the1B, the2B, the3B, hr: Int
    let r, rbi, bb, ibb: Int
    let so, hbp, sf, sh: Int
    let gdp: JSONNull?
    let sb, cs: Int
    let avg, obp, slg, ops: Double
    let wOBA, extendedBatterBB, k, bbK: Double
    let iso, spd, babip, ubr: Double
    let gdpRuns: JSONNull?
    let wRC, wRAA, uzr, wBsR: Double
    let baseRunning, war, off, def: Double
    let extendedBatterWRC, adp: Double
    let pos: Double?
    let minpos: String
    let teamid: Int?
    let league: String?
    let playerName, playerids, empty: String

    var description: String {
        "\(playerName): \(pos?.str ?? "") : \(team ?? "") "
    }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case team = "Team"
        case shortName = "ShortName"
        case g = "G"
        case ab = "AB"
        case pa = "PA"
        case h = "H"
        case the1B = "1B"
        case the2B = "2B"
        case the3B = "3B"
        case hr = "HR"
        case r = "R"
        case rbi = "RBI"
        case bb = "BB"
        case ibb = "IBB"
        case so = "SO"
        case hbp = "HBP"
        case sf = "SF"
        case sh = "SH"
        case gdp = "GDP"
        case sb = "SB"
        case cs = "CS"
        case avg = "AVG"
        case obp = "OBP"
        case slg = "SLG"
        case ops = "OPS"
        case wOBA
        case extendedBatterBB = "BB%"
        case k = "K%"
        case bbK = "BB/K"
        case iso = "ISO"
        case spd = "Spd"
        case babip = "BABIP"
        case ubr = "UBR"
        case gdpRuns = "GDPRuns"
        case wRC, wRAA
        case uzr = "UZR"
        case wBsR
        case baseRunning = "BaseRunning"
        case war = "WAR"
        case off = "Off"
        case def = "Def"
        case extendedBatterWRC = "wRC+"
        case adp = "ADP"
        case pos = "Pos"
        case minpos, teamid
        case league = "League"
        case playerName = "PlayerName"
        case playerids
        case empty = "."
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
}

// MARK: - AllExtendedBatters

struct AllExtendedBatters: Codable {
    
    
    static let steamer: ExtensionProjection = .init(projectionType: .steamer)
    static let atc: ExtensionProjection = .init(projectionType: .atc)
    static let theBat: ExtensionProjection = .init(projectionType: .thebat)
    static let theBatx: ExtensionProjection = .init(projectionType: .thebatx)
    static let depthCharts: ExtensionProjection = .init(projectionType: .depthCharts)

    static func batters(for projection: ProjectionTypes) -> [ParsedBatter] {
        switch projection {
            case .steamer:
                return AllExtendedBatters.steamer.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .zips:
                return AllExtendedBatters.steamer.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .thebat:
                return AllExtendedBatters.theBat.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .thebatx:
                return AllExtendedBatters.theBatx.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .atc:
                return AllExtendedBatters.atc.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .depthCharts:
                return AllExtendedBatters.depthCharts.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .myProjections:
                return Array(MainModel.shared.myModifiedBatters)
        }
    }

    static func batters(for projection: ProjectionTypes, at position: Position) -> [ParsedBatter] {
        var batters = batters(for: projection)
        batters = batters.filter { $0.positions.contains(position) }
        return batters
    }

    static func batterVariants(for batter: ParsedBatter) -> [ParsedBatter] {
        var retArr = [ParsedBatter]()
        for projection in ProjectionTypes.arr {
            let batters = batters(for: projection)
            if let foundBatter = batters.first(where: { $0 == batter }) {
                retArr.append(foundBatter)
            }
        }
        return retArr
    }
    
    

    
    
    
}

// MARK: - ExtensionProjection

struct ExtensionProjection {
    let c: [ParsedBatter]
    let firstBase: [ParsedBatter]
    let secondBase: [ParsedBatter]
    let thirdBase: [ParsedBatter]
    let ss: [ParsedBatter]
    let of: [ParsedBatter]
    var all: [ParsedBatter] { c + firstBase + secondBase + thirdBase + ss + of }

    init(c: [ParsedBatter], firstBase: [ParsedBatter], secondBase: [ParsedBatter], thirdBase: [ParsedBatter], ss: [ParsedBatter], of: [ParsedBatter]) {
        self.c = c
        self.firstBase = firstBase
        self.secondBase = secondBase
        self.thirdBase = thirdBase
        self.ss = ss
        self.of = of
    }

    init(projectionType: ProjectionTypes) {
        self.c = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .c)).map { ParsedBatter(from: $0, pos: .c, projectionType: projectionType) }
        self.firstBase = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .first)).map { ParsedBatter(from: $0, pos: .first, projectionType: projectionType) }
        self.secondBase = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .second)).map { ParsedBatter(from: $0, pos: .second, projectionType: projectionType) }
        self.thirdBase = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .third)).map { ParsedBatter(from: $0, pos: .third, projectionType: projectionType) }
        self.ss = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .ss)).map { ParsedBatter(from: $0, pos: .ss, projectionType: projectionType) }
        self.of = ExtensionProjection.loadBatters(projectionType.jsonFileName(position: .of)).map { ParsedBatter(from: $0, pos: .of, projectionType: projectionType) }
    }
    
    static func loadBatters(_ filename: String) -> [ExtendedBatter] {
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
            let arr = try decoder.decode([ExtendedBatter].self, from: data)
            return Array(Set<ExtendedBatter>(arr)).sorted(by: { $0.empty < $1.empty })
        } catch {
            fatalError("Couldn't parse \(filename) as \(JSONBatter.self):\n\(error)")
        }
    }
}

// MARK: - JSONNull

class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
