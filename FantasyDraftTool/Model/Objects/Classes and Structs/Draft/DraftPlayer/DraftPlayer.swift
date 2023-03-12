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
    let roundNumber: Int
    let pickInRound: Int
    
    /// Team that is assigned to the player. Not the computed property 
//    var draftTeam: DraftTeam
    var weightedScoreWhenDrafted: Double

    var description: String {
        [player.name, " \(player.projectionType.title)", "Round:", roundNumber.str, "Pick:", pickInRound.str].joinString(" ")
    }

    /// Computed property that tells you what team this player is found on within the draft 
    var draftedTeam: DraftTeam? {
        let team = MainModel.shared.draft.teams.first(where: { $0.draftedPlayers.contains(self) })
        return team
    }

    var id: String {
        "\(player.name) drafted #\(pickNumber) overall by."
    }
    
    static let TroutOrNull: DraftPlayer = .init(player: ParsedBatter.TroutOrNull, draft: .exampleDraft(picksMade: 0, model: MainModel.shared, projection: .atc))

    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        
        
//        if let parsedBatter = try? decoder.container.decode(ParsedBatter.self, forKey: .player) as? ParsedBatter {
//                    parsedPlayer = parsedBatter
//        } else if let parsedPitcher = try? decoder.container.decode(ParsedPitcher.self, forKey: .parsedPlayer) {
//                    parsedPlayer = parsedPitcher
//                } else {
//                    throw DecodingError.dataCorruptedError(forKey: .parsedPlayer, in: decoder.container, debugDescription: "Unable to decode ParsedPlayer")
//                }
        if let batter = try? values.decode(ParsedBatter.self, forKey: .player) {
            self.player = batter
        } else if let pitcher = try? values.decode(ParsedPitcher.self, forKey: .player) {
            self.player = pitcher
        } else {
           fatalError()
        }
//        self.player = try values.decodeIfPresent(ParsedBatter.self, forKey: .player)
//        self.player = try values.decode(ParsedPlayer.self, forKey: .player)
        self.pickNumber = try values.decode(Int.self, forKey: .pickNumber)
//        self.draftTeam = try values.decode(DraftTeam.self, forKey: .draftTeam)
        self.weightedScoreWhenDrafted = try values.decode(Double.self, forKey: .weightedScoreWhenDrafted)
        self.roundNumber = try values.decode(Int.self, forKey: .roundNumber)
        self.pickInRound = try values.decode(Int.self, forKey: .pickInRound)
    }

    init(player: ParsedPlayer, pickNumber: Int, round: Int, pickInRound: Int, weightedScore: Double) {
        self.player = player
        self.pickNumber = pickNumber
//        self.draftTeam = team
        self.weightedScoreWhenDrafted = weightedScore
//        if self.weightedScoreWhenDrafted.isNaN { weightedScoreWhenDrafted = 0 }
        self.roundNumber = round
        self.pickInRound = pickInRound
    }

    convenience init(player: ParsedPlayer, draft: Draft) {
        self.init(player: player,
                  pickNumber: draft.totalPickNumber,
                  round: draft.roundNumber,
                  pickInRound: draft.roundPickNumber,
                  weightedScore: player.zScore(draft: draft))
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
    enum CodingKeys: CodingKey { case player, pickNumber, draftTeam, weightedScoreWhenDrafted, roundNumber, pickInRound }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(player, forKey: .player)
        try container.encode(pickNumber, forKey: .pickNumber)
//        try container.encode(draftTeam, forKey: .draftTeam)
        if weightedScoreWhenDrafted.isNaN || weightedScoreWhenDrafted.isInfinite { weightedScoreWhenDrafted = 0 }
        try container.encode(weightedScoreWhenDrafted, forKey: .weightedScoreWhenDrafted)
        try container.encode(roundNumber, forKey: .roundNumber)
        try container.encode(pickInRound, forKey: .pickInRound)
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
