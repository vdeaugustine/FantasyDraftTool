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
    
    
}
