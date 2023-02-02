//
//  DraftPlayer.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - DraftPlayer

class DraftPlayer: Hashable, Codable, Equatable, Identifiable {
    // MARK: - Stored Properties

    var player: ParsedBatter
    var pickNumber: Int
    var team: DraftTeam
    var weightedScoreWhenDrafted: Double

    var id: String {
        "\(player.name) drafted #\(pickNumber) overall by \(team.name)."
    }
    

    // MARK: - Initializers
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.player = try values.decode(ParsedBatter.self, forKey: .player)
        self.pickNumber = try values.decode(Int.self, forKey: .pickNumber)
        self.team = try values.decode(DraftTeam.self, forKey: .team)
        self.weightedScoreWhenDrafted = try values.decode(Double.self, forKey: .weightedScoreWhenDrafted)
    }
    
    init(player: ParsedBatter, pickNumber: Int, team: DraftTeam, weightedScore: Double) {
        self.player = player
        self.pickNumber = pickNumber
        self.team = team
        self.weightedScoreWhenDrafted = weightedScore
    }
}

// MARK: - Codable, Hashable, Equatable

extension DraftPlayer {
    
    enum CodingKeys: CodingKey { case player, pickNumber, team, weightedScoreWhenDrafted }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(player, forKey: .player)
        try container.encode(pickNumber, forKey: .pickNumber)
        try container.encode(team, forKey: .team)
        try container.encode(weightedScoreWhenDrafted, forKey: .weightedScoreWhenDrafted)
    }
    
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
}
