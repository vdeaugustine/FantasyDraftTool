//
//  BestPick.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/3/23.
//

import Foundation
import SwiftUI

struct BestPick: Codable, Equatable, Hashable {
    let draftState: Draft
    
    var top10PlayersForPositionsNotFilled: [ParsedBatter] {
        var theseBatters: [ParsedBatter] = []
        
        for position in positionsNotFilled {
            theseBatters += draftState.playerPool.batters.filter(for: position)
        }
        
        theseBatters.sort { firstBatter, secondBatter in
            firstBatter.weightedFantasyPoints(dict: draftState.playerPool.positionAveragesDict) > secondBatter.weightedFantasyPoints(dict: draftState.playerPool.positionAveragesDict)
        }
        return theseBatters.prefixArray(10)
    }
    
    
    var positionsNotFilled: [Position] {
        guard let myTeam = draftState.myTeam else { return [] }
        var remainingPositions: [Position] = []
        
        for position in Position.batters {
            if myTeam.draftedPlayers.contains(where: {$0.player.positions.contains(position)}) {
                continue
            }
            remainingPositions.append(position)
        }
        return remainingPositions
    }

    func getTopPlayers(number: Int = 1) -> [ParsedBatter] {
        Array(draftState.playerPool.batters.sortedByPoints.prefix(number))
    }
    
    var topPlayer: ParsedBatter {
        getTopPlayers(number: 1).first ?? draftState.playerPool.batters[0]
    }
    
    
}
