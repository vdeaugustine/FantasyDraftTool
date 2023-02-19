//
//  ProjectionTypes.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

enum ProjectionTypes: String, CaseIterable, Codable {
    case steamer, zips, thebat, thebatx, atc, depthCharts, myProjections
    
    var str: String {
        switch self {
        case .steamer:
            return "Steamer"
        case .zips:
            return "zips"
        case .thebat:
            return "Thebat"
        case .thebatx:
            return "Thebatx"
        case .atc:
            return "Atc"
        case .depthCharts:
            return "Fangraphsdc"
        case .myProjections:
            return "My Projections"
        }
    }
    
    var title: String {
        switch self {
        case .steamer:
            return self.str
        case .zips:
            return "ZiPS"
        case .thebat:
            return "THE BAT"
        case .thebatx:
            return "THE BAT X"
        case .atc:
            return self.str.uppercased()
        case .depthCharts:
            return "Depth Charts"
        case .myProjections:
            return self.str
        }
    }

    static let arr: [ProjectionTypes] = [.steamer, .thebat, .thebatx, .atc, .depthCharts]
    static let allArr: [ProjectionTypes] = [.steamer, .thebat, .thebatx, .atc, .depthCharts, .myProjections]

    var jsonFile: String { "\(rawValue)Standard" }
    
    var extendedFile: String { "Extended" + jsonFile }
    
    func extendedFileName(position: Position) -> String {
        "Extended" + jsonFileName(position: position)
    }
    
    func jsonFileName(position: Position) -> String {
        position.str + "Bat" + self.str + "Standard"
    }
}
