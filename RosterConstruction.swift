//
//  RosterConstruction.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/14/23.
//

import Foundation

struct RosterConstruction: Codable, Hashable, Equatable {
    var minForPositions: [Position: Int] = [.c: 1,
                                            .first: 1,
                                            .second: 1,
                                            .third: 1,
                                            .ss: 1,
                                            .of: 3,
                                            .rp: 5,
                                            .sp: 5]

    let keysArr: [Position] = [.c,
                               .first,
                               .second,
                               .third,
                               .ss,
                               .of,
                               .rp,
                               .sp]

    var totalPlayers: Int = 25

    private enum CodingKeys: String, CodingKey {
        case totalPlayers, minForPositions, keysArr
    }

    init() { }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.totalPlayers = try values.decode(Int.self, forKey: .totalPlayers)
        self.minForPositions = try values.decode([Position: Int].self, forKey: .minForPositions)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalPlayers, forKey: .totalPlayers)
        try container.encode(minForPositions, forKey: .minForPositions)
    }

    static func == (lhs: RosterConstruction, rhs: RosterConstruction) -> Bool {
        return lhs.totalPlayers == rhs.totalPlayers && lhs.minForPositions == rhs.minForPositions
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(totalPlayers)
        hasher.combine(minForPositions)
    }
}
