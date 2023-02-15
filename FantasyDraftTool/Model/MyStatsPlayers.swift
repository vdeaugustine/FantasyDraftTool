//
//  MyStatsPlayers.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/2/23.
//

import Foundation


struct MyStatsPlayers: Codable, Hashable {
    var players: [MyStatsPlayer] = []
}

struct MyStatsPlayer: Codable, Hashable {
    var player: ParsedBatter
}
