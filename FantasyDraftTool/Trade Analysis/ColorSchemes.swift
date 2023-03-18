//
//  ColorSchemes.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/17/23.
//

import Foundation
import SwiftUI


extension MyColorScheme {
    static let mysterious: MyColorScheme = .init(first: "2C3333", second: "2E4F4F", third: "0E8388", fourth: "CBE4DE")
    static let myFirst: MyColorScheme = .init(first: "33434F", second: "4A555E", third: "305294", fourth: "BEBEBE")
//
//    static let niceBlue: Color = .hexStringToColor(hex: "305294")
//    static let niceGray: Color = .hexStringToColor(hex: "4A555E")
//    static let lighterGray: Color = .hexStringToColor(hex: "BEBEBE")
//    static let pointsGold: Color = .hexStringToColor(hex: "8B7500")
//    static let backgroundBlue: Color = .hexStringToColor(hex: "33434F")
}

struct SpecificColors: Codable, Hashable, Equatable {
    let backgroundStr: String
    let rectStr: String
    let lighterTextStr: String
    let niceStr: String
    
    var background: Color {
        .hexStringToColor(hex: backgroundStr)
    }
    
    var rect: Color {
        .hexStringToColor(hex: rectStr)
    }
    
    var lighter: Color {
        .hexStringToColor(hex: lighterTextStr)
    }
    
    var nice: Color {
        .hexStringToColor(hex: niceStr)
    }
    
    // Regular initializer
        init(backgroundStr: String, rectStr: String, lighterTextStr: String, niceStr: String) {
            self.backgroundStr = backgroundStr
            self.rectStr = rectStr
            self.lighterTextStr = lighterTextStr
            self.niceStr = niceStr
        }
    
    static let firstOne: SpecificColors = .init(backgroundStr: "33434F", rectStr: "4A555E", lighterTextStr: "BEBEBE", niceStr: "305294")
    static let mysterious: SpecificColors = .init(backgroundStr: "2C3333", rectStr: "2E4F4F", lighterTextStr: "CBE4DE", niceStr: "0E8388")
    static let nightSky = SpecificColors(backgroundStr: "0D1B2A", rectStr: "2E4A62", lighterTextStr: "C9D1D9", niceStr: "65A0CF")
    static let crimsonSunset = SpecificColors(backgroundStr: "1D1F1F", rectStr: "603A2E", lighterTextStr: "FFC09F", niceStr: "FF5733")
    static let goldenHarvest = SpecificColors(backgroundStr: "1E1E1E", rectStr: "5E442E", lighterTextStr: "EFD3A3", niceStr: "FFB94E")
    static let natureWalk = SpecificColors(backgroundStr: "232F21", rectStr: "3E5B48", lighterTextStr: "A1CDA8", niceStr: "679436")
    static let purpleHaze = SpecificColors(backgroundStr: "181818", rectStr: "39393A", lighterTextStr: "E1E1E1", niceStr: "B099C4")
    
    // Required implementation for Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(backgroundStr)
        hasher.combine(rectStr)
        hasher.combine(lighterTextStr)
        hasher.combine(niceStr)
    }
    
    // Required implementation for Equatable
    static func == (lhs: SpecificColors, rhs: SpecificColors) -> Bool {
        return lhs.backgroundStr == rhs.backgroundStr && lhs.rectStr == rhs.rectStr && lhs.lighterTextStr == rhs.lighterTextStr && lhs.niceStr == rhs.niceStr
    }
    
    // Required implementation for Codable
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(backgroundStr, forKey: .backgroundStr)
            try container.encode(rectStr, forKey: .rectStr)
            try container.encode(lighterTextStr, forKey: .lighterTextStr)
            try container.encode(niceStr, forKey: .niceStr)
        }
        
        // Required initializer for Codable
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            backgroundStr = try container.decode(String.self, forKey: .backgroundStr)
            rectStr = try container.decode(String.self, forKey: .rectStr)
            lighterTextStr = try container.decode(String.self, forKey: .lighterTextStr)
            niceStr = try container.decode(String.self, forKey: .niceStr)
        }
        
        // Coding keys for Codable
        enum CodingKeys: String, CodingKey {
            case backgroundStr
            case rectStr
            case lighterTextStr
            case niceStr
        }
}




struct MyColorScheme: Codable, Hashable, Equatable {
    let first: String
    let second: String
    let third: String
    let fourth: String
    
    var firstColor: Color { .hexStringToColor(hex: first) }
    var secondColor: Color { .hexStringToColor(hex: second) }
    var thirdColorColor: Color { .hexStringToColor(hex: third) }
    var fourthColor: Color {.hexStringToColor(hex: fourth)}
    
    
    init(first: String, second: String, third: String, fourth: String) {
        self.first = first
        self.second = second
        self.third = third
        self.fourth = fourth
    }
    
    
    
    static let key = "colorSchemeKey"
    enum CodingKeys: CodingKey {
        case first, second, third, fourth
    }
    
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decode(String.self, forKey: .first)
        second = try values.decode(String.self, forKey: .second)
        third = try values.decode(String.self, forKey: .third)
        fourth = try values.decode(String.self, forKey: .fourth)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(first, forKey: .first)
        try container.encode(second, forKey: .second)
        try container.encode(third, forKey: .third)
        try container.encode(fourth, forKey: .fourth)
    }
    
    
}
