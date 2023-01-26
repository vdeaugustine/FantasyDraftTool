//
//  StandardNaming.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/24/23.
//

import Foundation

enum Naming: String, Codable {
    case ab = "at bats"
    case h = "hits"
    case tb = "total bases"
    case r = "runs"
    case rbi
    case sb = "stolen bases"
    case cs = "caught stealing"
    case bb = "walks"
    case so = "strikeouts"

    var str: String {
        rawValue.count < 4 ? rawValue.uppercased() : rawValue.capitalized
        
    }

    static let cases: [Naming] = [tb,
                                  h,
                                  r,
                                  rbi,
                                  sb,
                                  cs,
                                  bb,
                                  so]
}
