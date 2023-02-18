//
//  ExtArray.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation
import SwiftUI

extension Array where Element == Double {
    func standardDeviation() -> Double {
        let count = Double(self.count)
        let average = self.reduce(0, +) / count
        let variance = self.map { pow($0 - average, 2) }.reduce(0, +) / count
        let standardDeviation = sqrt(variance)
        return standardDeviation
    }

}

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        Array(Set(self))
    }
}

extension Array {
    func prefixArray(_ num: Int) -> [Element] {
        Array(self.prefix(num))
    }
    
    func safeCheck(_ num: Int) -> Bool {
        return num >= 0 && num < self.count
    }
    
    func safeGet(at num: Int) -> Element? {
        guard safeCheck(num) else { return nil }
        return self[num]
    }
    
}

extension Array where Element == ParsedBatter {
    var sortedByPoints: [ParsedBatter] {
        self.removingDuplicates().sorted(by: {$0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints)})
    }
    
    func sortedByZscore(draft: Draft) -> [ParsedBatter] {
        let removedDuplicates = self.removingDuplicates()
        return removedDuplicates.sorted(by: {$0.zScore(draft: draft) > $1.zScore(draft: draft)})
    }
    
    func averagePoints(for: Position) -> Double {
        ParsedBatter.averagePoints(forThese: self)
    }
    
    func standardDeviation(for: Position) -> Double {
        self.map({$0.fantasyPoints(.defaultPoints)}).standardDeviation()
    }
    
    func filter(for position: Position) -> [ParsedBatter] {
        self.removingDuplicates().sortedByPoints.filter({$0.positions.contains(position)})
    }
    
    
    
}

extension GridItem {
    static func flexibleItems(_ amount: Int) -> [GridItem] {
        (0..<amount).map { _ in GridItem(.flexible())}
    }
    static func fixedItems(_ amount: Int, size: CGFloat) -> [GridItem] {
        (0..<amount).map { _ in GridItem(.fixed(size))}
    }
}
