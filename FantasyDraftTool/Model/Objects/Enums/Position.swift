//
//  Positions.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/25/23.
//

import Foundation

enum Position: Codable {
    case c, first, second, third, ss, of, dh, sp, rp

    /// Positions are returned in such a way that they can be used for accessing files names. (ie. 1B is 1b and SS is Ss)
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

    static let batters: [Position] =
        [Position.c,
         Position.first,
         Position.second,
         Position.third,
         Position.ss,
         Position.of]
}
