//
//  AllSavedPlayers.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/19/23.
//

import Foundation

class AllSavedPlayers: ObservableObject, Codable, Hashable {
    static func == (lhs: AllSavedPlayers, rhs: AllSavedPlayers) -> Bool {
        return lhs.sortedPlayers == rhs.sortedPlayers
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sortedPlayers)
    }
    
    var sortedPlayers: [ScoringSettings: [AnyParsedPlayer]] = [:]
    var shared: AllSavedPlayers = .init()
    
    
    enum CodingKeys: String, CodingKey {
        case sortedPlayers
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sortedPlayers, forKey: .sortedPlayers)
    }
    
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sortedPlayers = try container.decode([ScoringSettings: [AnyParsedPlayer]].self, forKey: .sortedPlayers)
    }
}
