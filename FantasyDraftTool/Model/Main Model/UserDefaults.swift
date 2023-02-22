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
    
    
}
