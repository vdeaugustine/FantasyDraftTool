//
//  ExtStr.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation
import SwiftUI

extension String {
    static let emptyString: String = ""

    func removeExtraneousMarks() -> String {
        var temp = self
        while let first = temp.first,
              first.isSymbol || first.isPunctuation || first.isWhitespace {
            temp.removeFirst()
        }
        while let last = temp.last,
              last.isSymbol || last.isPunctuation || last.isWhitespace {
            temp.removeLast()
        }
        return temp
    }

    func join(with otherStrings: [String], _ separator: String = " ") -> String {
        var arr = otherStrings
        arr.insert(self, at: 0)
        return arr.joined(separator: separator)
    }

    func removingWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func spacedWith(_ secondString: String) -> some View {
        HStack {
            Text(self)
            Spacer()
            Text(secondString)
        }
    }

    func removeAllAfter(_ character: String) -> String {
        var str = self
        if let charRange = str.range(of: character) {
            str.removeSubrange(charRange.lowerBound ..< str.endIndex)
        }
        return str
    }

    func removeAllAfterAndIncluding(_ character: String) -> String {
        var str = self
        if let charRange = str.range(of: character) {
            str.removeSubrange(charRange.lowerBound ... str.endIndex)
        }
        return str
    }

    func makeMoney(makeCents: Bool) -> String {
        var amount: Double = 0
        if let dub = Double(self) {
            amount = makeCents ? (dub / 100) : dub
        }
        return amount.formattedForMoney(includeCents: makeCents)
    }

    func makeText() -> some View {
        Text(self)
    }

    func getDoubleFromMoney() -> Double? {
        let editedStr = replacingOccurrences(of: "$", with: "")
        return Double(editedStr)
    }

    mutating func removeOccurrences(_ characters: [any StringProtocol]) {
        for character in characters {
            self = replacingOccurrences(of: character, with: "")
        }
    }
}
