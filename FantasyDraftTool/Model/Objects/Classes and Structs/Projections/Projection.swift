//
//  Projection.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

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
        self.c = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .c)).map { ParsedBatter(from: $0, pos: .c, projectionType: projectionType) }
        self.firstBase = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .first)).map { ParsedBatter(from: $0, pos: .first, projectionType: projectionType) }
        self.secondBase = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .second)).map { ParsedBatter(from: $0, pos: .second, projectionType: projectionType) }
        self.thirdBase = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .third)).map { ParsedBatter(from: $0, pos: .third, projectionType: projectionType) }
        self.ss = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .ss)).map { ParsedBatter(from: $0, pos: .ss, projectionType: projectionType) }
        self.of = JSONBatter.loadBatters(projectionType.jsonBatterFileName(position: .of)).map { ParsedBatter(from: $0, pos: .of, projectionType: projectionType) }
    }
}
