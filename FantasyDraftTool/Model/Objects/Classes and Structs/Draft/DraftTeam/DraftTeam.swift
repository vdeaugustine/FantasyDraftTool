//
//  DraftTeam.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - DraftTeam

class DraftTeam: Hashable, Codable, Equatable, CustomStringConvertible {
    // MARK: Stored Properties

    var name: String
    var draftPosition: Int
    var positionsRequired: [Position: Int]
    var draftedPlayers: [DraftPlayer]

    var description: String {
        let starting: String = "# \(draftPosition): \(name) "
        return draftedPlayers.reduce(starting) { $0 + $1.player.name + ", " }
    }

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

    // MARK: - Calculations

    func averagePoints() -> Double {
        let players = draftedPlayers
        let val: Double = players.reduce(Double(0)) { $0 + $1.player.fantasyPoints(.defaultPoints) }
        return (val / Double(players.count)).roundTo(places: 1)
    }

    func points(for position: Position) -> Double {
        let theseBatters = draftedPlayers.filter { $0.player.positions.contains(position) }
        guard !theseBatters.isEmpty else {
            return 0
        }
        let sum: Double = theseBatters.reduce(Double(0)) { $0 + $1.player.fantasyPoints(.defaultPoints) }
        return (sum / Double(theseBatters.count)).roundTo(places: 1)
    }
    
    func players(for position: Position) -> [DraftPlayer] {
        draftedPlayers.filter{$0.player.positions.contains(position)}
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
            lhs.positionsRequired == rhs.positionsRequired // &&
//            lhs.draftedPlayers == rhs.draftedPlayers
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(draftPosition)
        hasher.combine(positionsRequired)
//        hasher.combine(draftedPlayers)
    }
}

// MARK: - Some default values

extension DraftTeam {
    static func someDefaultTeams(amount: Int) -> [DraftTeam] {
        (0 ..< amount).map {
            DraftTeam(name: "Team \($0 + 1)", draftPosition: $0)
        }
    }
}
