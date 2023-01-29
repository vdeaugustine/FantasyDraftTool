//
//  DraftPlayer.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

class DraftPlayer: Hashable {
    var player: ParsedBatter
    var pickNumber: Int
    var team: DraftTeam
    
    static func == (lhs: DraftPlayer, rhs: DraftPlayer) -> Bool {
        return lhs.player == rhs.player &&
        lhs.pickNumber == rhs.pickNumber &&
        lhs.team == rhs.team
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(player)
        hasher.combine(pickNumber)
        hasher.combine(team)
    }
    
    init(player: ParsedBatter, pickNumber: Int, team: DraftTeam) {
        self.player = player
        self.pickNumber = pickNumber
        self.team = team
    }
}
