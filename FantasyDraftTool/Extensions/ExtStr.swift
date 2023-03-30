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

    /// An extension to the String type that provides a method for joining the string with other strings using a separator.
    ///
    /// - Parameters:
    /// - otherStrings: An array of strings to join with the original string.
    /// - separator: The separator to use when joining the strings. Default is a single space character.
    /// - Returns: A new string that is the result of joining the original string with the other strings using the specified separator.
    ///
    /// This extension adds a method to the String type that joins the original string with other strings using a separator. The method accepts an array of strings to join with the original string, and a separator string that defaults to a single space character. The method creates a new array containing the original string and the other strings, and then uses the joined(separator:) method to join the elements of the array into a new string using the specified separator. The resulting string is then returned.
    func join(with otherStrings: [String], _ separator: String = " ") -> String {
        var arr = otherStrings
        arr.insert(self, at: 0)
        return arr.joined(separator: separator)
    }

    /// An extension to the String type that provides a method for removing all white spaces from the string.
    ///
    /// - Returns: A new string with all white spaces removed.
    ///
    /// This extension adds a method to the String type that removes all white spaces from the string using the components(separatedBy:) method to split the string into an array of substrings separated by whitespace characters, and then joining the substrings back together using the joined() method. The resulting string has all white spaces removed.
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

    
    /// An extension to the String type that provides a method for removing all characters in the string after a specified character.
    ///
    /// - Parameter character: The character after which to remove all characters in the string.
    ///
    /// - Returns: A new string with all characters after the specified character removed.
    ///
    /// This extension adds a method to the String type that removes all characters in the string after a specified character. The method first finds the range of the specified character using the range(of:) method.

    /// If the character is found in the string, the method removes all characters in the string after the specified character using the removeSubrange(_:) method, and returns the modified string.

    /// If the character is not found in the string, the method returns the original string.
    func removeAllAfter(_ character: String) -> String {
        var str = self
        if let charRange = str.range(of: character) {
            str.removeSubrange(charRange.lowerBound ..< str.endIndex)
        }
        return str
    }

    /// An extension to the String type that provides a method for removing all characters in the string after and including a specified character.
    ///
    /// - Parameter character: The character after which to remove all characters in the string.
    ///
    /// - Returns: A new string with all characters after and including the specified character removed.
    ///
    /// This extension adds a method to the String type that removes all characters in the string after and including a specified character. The method first finds the range of the specified character using the range(of:) method.

    /// If the character is found in the string, the method removes all characters in the string after and including the specified character using the removeSubrange(_:) method, and returns the modified string.

    /// If the character is not found in the string, the method returns the original string.
    func removeAllAfterAndIncluding(_ character: String) -> String {
        var str = self
        if let charRange = str.range(of: character) {
            str.removeSubrange(charRange.lowerBound ... str.endIndex)
        }
        return str
    }

    /// An extension to the String type that provides a method for formatting a string as a dollar amount.
    ///
    /// - Parameter makeCents: A Boolean value indicating whether to include cents in the formatted string.
    ///
    /// - Returns: A string formatted as a dollar amount, with or without cents depending on the value of makeCents.
    ///
    /// This extension adds a method to the String type that formats a string as a dollar amount. The method first attempts to convert the string to a Double value using the Double(_:) initializer.

    /// If the conversion is successful, the resulting Double value is divided by 100 if makeCents is true, and then passed to the formattedForMoney(includeCents:) method to create a formatted string.

    /// If the conversion is unsuccessful, the method returns an empty string.
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

    /// An extension to the String type that provides a method for extracting a Double value from a string containing a dollar amount.
    ///
    /// - Returns: An optional Double representing the dollar amount extracted from the string.
    ///
    /// This extension adds a method to the String type that extracts a Double value from a string that contains a dollar amount. The method first removes the dollar sign ($) from the string using the replacingOccurrences(of:with:) method.

    /// Then, it attempts to convert the resulting string to a Double value using the Double(_:) initializer.

    /// If the string can be converted to a Double value, the resulting Double value is returned as an optional. If the string cannot be converted to a Double value, the method returns nil.
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
