//
//  DraftPlayer.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - DraftPlayer

class DraftPlayer: Hashable, Codable, Equatable, Identifiable, CustomStringConvertible {
    // MARK: - Stored Properties

    var player: ParsedPlayer
    var pickNumber: Int
    
    /// Team that is assigned to the player. Not the computed property 
//    var draftTeam: DraftTeam
    var weightedScoreWhenDrafted: Double

    var description: String {
        player.name + " \(player.projectionType.title)"
    }

    /// Computed property that tells you what team this player is found on within the draft 
    var draftedTeam: DraftTeam? {
        let team = MainModel.shared.draft.teams.first(where: { $0.draftedPlayers.contains(self) })
        return team
    }

    var id: String {
        "\(player.name) drafted #\(pickNumber) overall by."
    }

    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.player = try values.decode(ParsedBatter.self, forKey: .player)
        self.pickNumber = try values.decode(Int.self, forKey: .pickNumber)
//        self.draftTeam = try values.decode(DraftTeam.self, forKey: .draftTeam)
        self.weightedScoreWhenDrafted = try values.decode(Double.self, forKey: .weightedScoreWhenDrafted)
    }

    init(player: ParsedPlayer, pickNumber: Int, team: DraftTeam, weightedScore: Double) {
        self.player = player
        self.pickNumber = pickNumber
//        self.draftTeam = team
        self.weightedScoreWhenDrafted = weightedScore
    }

    convenience init(player: ParsedPlayer, draft: Draft) {
        self.init(player: player,
                  pickNumber: draft.totalPickNumber,
                  team: draft.currentTeam,
                  weightedScore: player.zScore(draft: draft, limit: 150))
    }
}

// MARK: - Functions

extension DraftPlayer {
    func has(position: Position) -> Bool  {
        guard let batter = player as? ParsedBatter else { return false }
        return batter.positions.contains(position)
    }

    // MARK: - Static functions
}

// MARK: - Codable, Hashable, Equatable

extension DraftPlayer {
    enum CodingKeys: CodingKey { case player, pickNumber, draftTeam, weightedScoreWhenDrafted }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(player, forKey: .player)
        try container.encode(pickNumber, forKey: .pickNumber)
//        try container.encode(draftTeam, forKey: .draftTeam)
        try container.encode(weightedScoreWhenDrafted, forKey: .weightedScoreWhenDrafted)
    }

    static func == (lhs: DraftPlayer, rhs: DraftPlayer) -> Bool {
        return lhs.pickNumber == rhs.pickNumber && lhs.player.name == rhs.player.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(player.name)
        hasher.combine(pickNumber)
        ////hasher.combine(draftTeam)
    }
}
