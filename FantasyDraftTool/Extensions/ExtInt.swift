//
//  ExtInt.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation

extension Int {
    var str: String {
        "\(self)"
    }

    func formatForMoney() -> String {
        let dub = Double(self)
        return dub.formattedForMoney()
    }
    
    var isEven: Bool {
        self % 2 == 0
    }
    
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
    
    public func isMultiple(of other: Int) -> Bool {
        self % other == 0
    }
    
    
}
