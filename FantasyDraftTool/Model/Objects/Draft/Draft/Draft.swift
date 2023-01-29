//
//  Draft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

class Draft {
    let teams: [DraftTeam]
    var currentPickNumber: Int
    let settings: DraftSettings
    
    init(teams: [DraftTeam], currentPickNumber: Int, settings: DraftSettings) {
        self.teams = teams
        self.currentPickNumber = currentPickNumber
        self.settings = settings
    }
}
