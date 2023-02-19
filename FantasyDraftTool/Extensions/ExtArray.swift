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
        let average = reduce(0, +) / count
        let variance = map { pow($0 - average, 2) }.reduce(0, +) / count
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
        Array(prefix(num))
    }

    func safeCheck(_ num: Int) -> Bool {
        return num >= 0 && num < count
    }

    func safeGet(at num: Int) -> Element? {
        guard safeCheck(num) else { return nil }
        return self[num]
    }
}

extension Array where Element == ParsedBatter {
    var sortedByPoints: [ParsedBatter] {
        removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
    }

    func sortedByZscore(draft: Draft) -> [ParsedBatter] {
        let removedDuplicates = removingDuplicates()
        return removedDuplicates.sorted(by: { $0.zScore(draft: draft) > $1.zScore(draft: draft) })
    }

    func averagePoints(for: Position) -> Double {
        ParsedBatter.averagePoints(forThese: self)
    }

    func standardDeviation(for: Position) -> Double {
        map { $0.fantasyPoints(.defaultPoints) }.standardDeviation()
    }

    func filter(for position: Position) -> [ParsedBatter] {
        removingDuplicates().sortedByPoints.filter { $0.positions.contains(position) }
    }

    func filter(for positions: [Position]) -> [ParsedBatter] {
        removingDuplicates().sortedByPoints.filter { $0.positions.intersects(with: positions) }
    }
}


extension Array where Element == DraftPlayer {
    
    func filter(for position: Position) -> [DraftPlayer] {
        removingDuplicates().filter { $0.player.positions.contains(position) }
    }

    func filter(for positions: [Position]) -> [DraftPlayer] {
        removingDuplicates().filter { $0.player.positions.intersects(with: positions) }
    }
    
    var sortedByPoints: [DraftPlayer] {
        removingDuplicates().sorted(by: { $0.player.fantasyPoints(.defaultPoints) > $1.player.fantasyPoints(.defaultPoints) })
    }

    func sortedByZscore(draft: Draft) -> [DraftPlayer] {
        let removedDuplicates = removingDuplicates()
        return removedDuplicates.sorted(by: { $0.player.zScore(draft: draft) > $1.player.zScore(draft: draft) })
    }
    
    
}

extension Sequence where Iterator.Element: Hashable {
    func intersects<S: Sequence>(with sequence: S) -> Bool
        where S.Iterator.Element == Iterator.Element {
        let sequenceSet = Set(sequence)
        return contains(where: sequenceSet.contains)
    }
}

extension Array where Element == Position {
    var str: String {
        return reduce("") { $0 + ", " + $1.str.uppercased() }
    }

    var corOrder: [Element] {
        sorted(by: {
            let val1: Int
            let val2: Int
            switch $0 {
                case .c:
                    val1 = 0
                case .first:
                    val1 = 1
                case .second:
                    val1 = 2
                case .third:
                    val1 = 3
                case .ss:
                    val1 = 4
                case .of:
                    val1 = 5
                case .dh:
                    val1 = 6
                case .sp:
                    val1 = 7
                case .rp:
                    val1 = 8
            }

            switch $1 {
                case .c:
                    val2 = 0
                case .first:
                    val2 = 1
                case .second:
                    val2 = 2
                case .third:
                    val2 = 3
                case .ss:
                    val2 = 4
                case .of:
                    val2 = 5
                case .dh:
                    val2 = 6
                case .sp:
                    val2 = 7
                case .rp:
                    val2 = 8
            }

            return val1 < val2
        }
        )
    }
}

extension GridItem {
    static func flexibleItems(_ amount: Int) -> [GridItem] {
        (0 ..< amount).map { _ in GridItem(.flexible()) }
    }

    static func fixedItems(_ amount: Int, size: CGFloat) -> [GridItem] {
        (0 ..< amount).map { _ in GridItem(.fixed(size)) }
    }
}
