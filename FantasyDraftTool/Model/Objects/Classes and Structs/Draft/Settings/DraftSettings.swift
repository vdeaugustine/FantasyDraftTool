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
    var rosterRequirements: RosterRequirements = .init()
    
    
    static let defaultSettings: DraftSettings = .init(
        numberOfTeams: 10,
        snakeDraft: true,
        numberOfRounds: 25,
        scoringSystem: .defaultPoints
    )
    
}

struct RosterRequirements: Codable, Equatable, Hashable {
    var positionsRequired: Set<Position> = Set(Position.batters)
    var maxForPositions: [Position: Int?] = Dictionary(uniqueKeysWithValues: Position.batters.map({($0, nil)}))
}
