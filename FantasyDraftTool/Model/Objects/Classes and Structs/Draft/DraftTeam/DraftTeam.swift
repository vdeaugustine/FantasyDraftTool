//
//  DraftTeam.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - DraftTeam

class DraftTeam: Hashable, Codable, Equatable {
    // MARK: Stored Properties

    var name: String
    var draftPosition: Int
    var positionsRequired: [Position: Int]
    var draftedPlayers: [DraftPlayer]

    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.draftPosition = try container.decode(Int.self, forKey: .draftPosition)
        self.positionsRequired = try container.decode([Position: Int].self, forKey: .positionsRequired)
        self.draftedPlayers = try container.decode([DraftPlayer].self, forKey: .draftedPlayers)
    }

    init(name: String, draftPosition: Int, positionsRequired: [Position: Int] = [:], draftedPlayers: [DraftPlayer] = []) {
        self.name = name
        self.draftPosition = draftPosition
        self.positionsRequired = positionsRequired
        self.draftedPlayers = draftedPlayers
    }
}

// MARK: - Codable Equatable, Hashable

extension DraftTeam {
    private enum CodingKeys: String, CodingKey {
        case name
        case draftPosition
        case positionsRequired
        case draftedPlayers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(draftPosition, forKey: .draftPosition)
        try container.encode(positionsRequired, forKey: .positionsRequired)
        try container.encode(draftedPlayers, forKey: .draftedPlayers)
    }

    static func == (lhs: DraftTeam, rhs: DraftTeam) -> Bool {
        return lhs.name == rhs.name &&
            lhs.draftPosition == rhs.draftPosition &&
            lhs.positionsRequired == rhs.positionsRequired &&
            lhs.draftedPlayers == rhs.draftedPlayers
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(draftPosition)
        hasher.combine(positionsRequired)
        hasher.combine(draftedPlayers)
    }
}
