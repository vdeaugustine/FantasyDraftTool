//
//  DraftSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

struct DraftSettings: Codable, Equatable, Hashable {
    let numberOfTeams: Int
    let snakeDraft: Bool
    let numberOfRounds: Int
    var playersPerTeam: Int { numberOfRounds }
    let scoringSystem: ScoringSettings
}
