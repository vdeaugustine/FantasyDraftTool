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
}

// MARK: - AllParsedBatters

struct AllParsedBatters {
    static let steamer: Projection = .init(projectionType: .steamer)
    static let atc: Projection = .init(projectionType: .atc)
    static let theBat: Projection = .init(projectionType: .thebat)
    static let theBatx: Projection = .init(projectionType: .thebatx)
    static let depthCharts: Projection = .init(projectionType: .depthCharts)
}

// MARK: - Projection

class Projection {
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
        self.c = JSONBatter.loadBatters(projectionType.jsonFileName(position: .c)).map { ParsedBatter(from: $0) }
        self.firstBase = JSONBatter.loadBatters(projectionType.jsonFileName(position: .first)).map { ParsedBatter(from: $0) }
        self.secondBase = JSONBatter.loadBatters(projectionType.jsonFileName(position: .second)).map { ParsedBatter(from: $0) }
        self.thirdBase = JSONBatter.loadBatters(projectionType.jsonFileName(position: .third)).map { ParsedBatter(from: $0) }
        self.ss = JSONBatter.loadBatters(projectionType.jsonFileName(position: .ss)).map { ParsedBatter(from: $0) }
        self.of = JSONBatter.loadBatters(projectionType.jsonFileName(position: .of)).map { ParsedBatter(from: $0) }
        
    }
}

// MARK: - Steamer

class Steamer: Projection {
    override init(c: [ParsedBatter], firstBase: [ParsedBatter], secondBase: [ParsedBatter], thirdBase: [ParsedBatter], ss: [ParsedBatter], of: [ParsedBatter]) {
        super.init(c: c, firstBase: firstBase, secondBase: secondBase, thirdBase: thirdBase, ss: ss, of: of)
    }
}
