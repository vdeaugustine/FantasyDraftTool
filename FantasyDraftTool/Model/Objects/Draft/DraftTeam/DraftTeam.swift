//
//  DraftTeam.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

class DraftTeam: Hashable {
    var name: String
    var draftPosition: Int
    var positionsRequired: [Positions: Int]
    var draftedPlayers: [DraftPlayer]
    
    static func == (lhs: DraftTeam, rhs: DraftTeam) -> Bool {
        return lhs.name == rhs.name &&
        lhs.draftPosition == rhs.draftPosition
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(draftPosition)
    }
    
    init(name: String, draftPosition: Int, positionsRequired: [Positions : Int] = [:], draftedPlayers: [DraftPlayer] = []) {
        self.name = name
        self.draftPosition = draftPosition
        self.positionsRequired = positionsRequired
        self.draftedPlayers = draftedPlayers
    }
    
}
