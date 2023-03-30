//
//  ExtInt.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation

extension Int {
    /// A computed property that returns a string representation of the numeric value.
    ///
    /// - Returns: A string representation of the numeric value.
    ///
    /// This property simply returns the string representation of the original numeric value self.

    /// The resulting string is then returned as the result of this property.
    var str: String {
        "\(self)"
    }

    /// A utility function that formats a numeric value as a currency string.
    ///
    /// - Returns: A formatted string representation of the numeric value as a currency.
    ///
    /// This function first creates a Double value from the original integer value self. It then calls the formattedForMoney() method of the Double type to format the value as a currency string.

    /// The resulting string is then returned as the result of this function.
    func formatForMoney() -> String {
        let dub = Double(self)
        return dub.formattedForMoney()
    }
    
    var isEven: Bool {
        self % 2 == 0
    }
    
    /// An extension to the Int type that provides a computed property for converting an integer to a string with a suffix indicating the position of the number.
    ///
    /// - Returns: A String representation of the integer with a suffix indicating its position.
    ///
    /// This extension adds a computed property to the Int type that converts an integer to a string with a suffix indicating its position. The function addSuffixToNumber is called to add the appropriate suffix to the number based on its value.

    /// The suffixes added are "st" for numbers ending in 1 (except for numbers ending in 11), "nd" for numbers ending in 2 (except for numbers ending in 12), "rd" for numbers ending in 3 (except for numbers ending in 13), and "th" for all other numbers.

    /// The resulting string is then returned as the result of this computed property.
    var withSuffix: String {
        func addSuffixToNumber(_ number: Int) -> String {
            let suffix: String
            switch number % 10 {
            case 1 where number % 100 != 11:
                suffix = "st"
            case 2 where number % 100 != 12:
                suffix = "nd"
            case 3 where number % 100 != 13:
                suffix = "rd"
            default:
                suffix = "th"
            }
            return "\(number)\(suffix)"
        }
        return addSuffixToNumber(self)
    }
    
    /// An extension to the Int type that provides a method for checking whether one integer is a multiple of another.
    ///
    /// - Parameters:
    /// - other: The integer value to check against.
    ///
    /// - Returns: A Boolean value indicating whether the integer is a multiple of the specified value.
    ///
    /// This extension adds a method to the Int type that checks whether the integer is a multiple of another specified integer. It does this by checking whether the remainder of the division of the two integers is zero.

    /// If the remainder is zero, this method returns true, indicating that the integer is a multiple of the specified value. Otherwise, it returns false.

    /// The resulting Boolean value is then returned as the result of this method.
    public func isMultiple(of other: Int) -> Bool {
        self % other == 0
    }
    
    
}
