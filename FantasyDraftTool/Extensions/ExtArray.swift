//
//  ExtArray.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        Array(Set(self))
    }
}
