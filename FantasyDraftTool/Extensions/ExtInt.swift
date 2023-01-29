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
}
