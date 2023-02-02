//
//  DraftSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

struct DraftSettings: Codable, Equatable, Hashable {
    var numberOfTeams: Int
    var snakeDraft: Bool
    var numberOfRounds: Int
    var playersPerTeam: Int { numberOfRounds }
    var scoringSystem: ScoringSettings
}
