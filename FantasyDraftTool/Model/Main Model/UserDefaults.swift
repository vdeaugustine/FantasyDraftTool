//
//  UserDefaults.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/2/23.
//

import Foundation

extension UserDefaults {
    
    static var isCurrentlyInDraft: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isCurrentlyInDraft")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "isCurrentlyInDraft")
        }
    }
    
    
    static func keyFor(player: ParsedBatter, scoringSettings: ScoringSettings, projection: ProjectionTypes) -> String {
        "\(projection.str)-\(player)-\(scoringSettings.defaultsKey)"
    }
    
    static func pointsFor(player: ParsedBatter, scoring: ScoringSettings, projection: ProjectionTypes) -> Double {
        let key = keyFor(player: player, scoringSettings: scoring, projection: projection)
        if let foundValue: Double = UserDefaults.standard.value(forKey: key) as? Double {
            return foundValue
        }
        
        let points = player.fantasyPoints(scoring)
        
        UserDefaults.standard.set(points, forKey: key)
        
        return points
    }
    
    
}
