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
            return "1b"
        case .second:
            return "2b"
        case .third:
            return "3b"
        case .ss:
            return "Ss"
        case .of:
            return "Of"
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
