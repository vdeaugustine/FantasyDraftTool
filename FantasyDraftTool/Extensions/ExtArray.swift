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

extension Array {
    func prefixArray(_ num: Int) -> [Element] {
        Array(self.prefix(num))
    }
}

extension Array where Element == ParsedBatter {
    var sortedByPoints: [ParsedBatter] {
        self.removingDuplicates().sorted(by: {$0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints)})
    }
    
    func averagePoints(for: Position) -> Double {
        ParsedBatter.averagePoints(forThese: self)
    }
    
    func filter(for position: Position) -> [ParsedBatter] {
        self.removingDuplicates().sortedByPoints.filter({$0.positions.contains(position)})
    }
    
}
