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

    static var positionLimit: Int {
        get {
            let stored = UserDefaults.standard.integer(forKey: "positionLimit")
            return stored > 0 ? stored : 150
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "positionLimit")
            print("Set \(newValue) for position limit. Proof: ", positionLimit)
        }
    }

    static func lastUpdated(for projection: ProjectionTypes, and position: Position) -> Date? {
        let key = "\(projection.str)-\(position.str)"
        return UserDefaults.standard.value(forKey: key) as? Date
    }

    static func updateIfNecessary(for projectionType: ProjectionTypes, and position: Position) {
        let key = "\(projectionType.str)-\(position.str)"
        if let lastUpdate = lastUpdated(for: projectionType, and: position) {
            guard !lastUpdate.isSameDayAs(.now) else {
                return
            }
        }
        standard.set(Date.now, forKey: key)
    }
    
    static func needingUpdate() -> [(projection: ProjectionTypes, position: Position)] {
        var retArr = [(projection: ProjectionTypes, position: Position)]()
        
        for proj in ProjectionTypes.batterArr {
            for pos in Position.batters {
                guard let lastUpdate = lastUpdated(for: proj, and: pos),
                      lastUpdate.isSameDayAs(.now) else {
                    retArr.append((projection: proj, position: pos))
                    continue
                }
            }
        }
        
        return retArr
        
    }
}
