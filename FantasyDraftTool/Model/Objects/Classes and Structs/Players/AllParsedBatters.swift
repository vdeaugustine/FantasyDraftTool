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

    static func batters(for projection: ProjectionTypes, scoring: ScoringSettings? = nil) -> [ParsedBatter] {
        
        var players: [ParsedBatter] = []
        
        switch projection {
            case .steamer:
                players = AllParsedBatters.steamer.all.removingDuplicates()
            case .zips:
                players = AllParsedBatters.steamer.all.removingDuplicates()
            case .thebat:
                players = AllParsedBatters.theBat.all.removingDuplicates()
            case .thebatx:
                players = AllParsedBatters.theBatx.all.removingDuplicates()
            case .atc:
                players = AllParsedBatters.atc.all.removingDuplicates()
            case .depthCharts:
                players = AllParsedBatters.depthCharts.all.removingDuplicates()
            case .myProjections:
                players = Array(MainModel.shared.myModifiedBatters)
        }
        
        if let scoring = scoring {
            return players.sorted(by: { $0.fantasyPoints(scoring) > $1.fantasyPoints(scoring) })
        } else {
            return players
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
