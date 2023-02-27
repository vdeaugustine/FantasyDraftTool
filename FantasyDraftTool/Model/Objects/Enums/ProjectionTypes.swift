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

    static let batterArr: [ProjectionTypes] = [.steamer, .thebat, .thebatx, .atc, .depthCharts]
    static let allArr: [ProjectionTypes] = [.steamer, .thebat, .thebatx, .atc, .depthCharts, .myProjections]
    static let pitcherArr: [ProjectionTypes] = [.steamer, .thebat, .atc, .depthCharts]

    var jsonFile: String { "\(rawValue)Standard" }
    
    var extendedFile: String { "Extended" + jsonFile }
    
    func extendedFileName(position: Position) -> String {
        "Extended" + jsonBatterFileName(position: position)
    }
    
    func extendedFileName(pitcherType: PitcherType) -> String {
        "Extended" + jsonPitcherFileName(type: pitcherType)
    }
    
    func jsonBatterFileName(position: Position) -> String {
        position.str + "Bat" + self.str + "Standard"
    }
    
    func jsonPitcherFileName(type: PitcherType) -> String {
        switch type {
        case .starter:
            return "Sta" + self.str + "Standard"
        case .reliever:
            return "Rel" + self.str + "Standard"
        }
        
    }
}
