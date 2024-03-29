//
//  AllParsedBatters.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - AllParsedBatters

struct AllParsedBatters {
    static let steamer: Projection = .init(projectionType: .steamer)
    static let atc: Projection = .init(projectionType: .atc)
    static let theBat: Projection = .init(projectionType: .thebat)
    static let theBatx: Projection = .init(projectionType: .thebatx)
    static let depthCharts: Projection = .init(projectionType: .depthCharts)

    static func batters(for projection: ProjectionTypes) -> [ParsedBatter] {
        switch projection {
            case .steamer:
                return AllParsedBatters.steamer.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .zips:
                return AllParsedBatters.steamer.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .thebat:
                return AllParsedBatters.theBat.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .thebatx:
                return AllParsedBatters.theBatx.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .atc:
                return AllParsedBatters.atc.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
            case .depthCharts:
                return AllParsedBatters.depthCharts.all.removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
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
        for projection in ProjectionTypes.batterArr {
            let batters = batters(for: projection)
            if let foundBatter = batters.first(where: { $0 == batter }) {
                retArr.append(foundBatter)
            }
        }
        return retArr
    }
    
    
}
