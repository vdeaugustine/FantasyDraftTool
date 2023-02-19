//
//  CoreDataExtensions.swift
//  EarningsVisualizer
//
//  Created by Vincent DeAugustine on 12/20/22.
//

import Foundation
import CoreData


extension NSPersistentContainer {
    func save() {
        do {
            try self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UserDefaults {
    static var appOpenAmount: Int {
        get {
            UserDefaults.standard.integer(forKey: "appOpenAmount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appOpenAmount")
        }
    }
    
    
    
    
    
    
    
    
}



