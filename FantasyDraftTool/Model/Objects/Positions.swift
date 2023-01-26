//
//  Positions.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/25/23.
//

import Foundation

enum Positions {
    case c,
         first,
         second,
         third,
         ss,
         of,
         dh,
         sp,
         rp
    
    var str: String {
        switch self {
        case .c:
            return "C"
        case .first:
            return "1B"
        case .second:
            return "2B"
        case .third:
            return "3B"
        case .ss:
            return "SS"
        case .of:
            return "OF"
        case .dh:
            return "DH"
        case .sp:
            return "SP"
        case .rp:
            return "RP"
        }
    }

    static let batters: [Positions] =
        [Positions.c,
         Positions.first,
         Positions.second,
         Positions.third,
         Positions.ss,
         Positions.of]
    
}
