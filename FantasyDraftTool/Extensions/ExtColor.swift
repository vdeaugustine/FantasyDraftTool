//
//  ExtColor.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation
import SwiftUI

extension Color {
    
    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let r, g, b: UInt64
            switch hex.count {
            case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            default: (r, g, b) = (0, 0, 0)
            }
            self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
        }
    
    
    static var listBackground: Color { .hexStringToColor(hex: "F2F2F7") }
    
    
    static func getColorStrFromValue(_ value: Double) -> String {
        var hexColor: String = ""
        
        if value <= 0 {
            // If value is 0 or less, return blue hex color
            hexColor = "#0000FF"
        } else if value >= 1 {
            // If value is 1 or more, return red hex color
            hexColor = "#FF0000"
        } else {
            // Calculate blend value based on input value
            let blendValue = CGFloat(value) * 2
            
            // Calculate red, green, and blue color components for blend
            let red = Int((1 - blendValue) * 255 + blendValue * 255)
            let green = Int((1 - blendValue) * 255 + blendValue * 255)
            let blue = Int((1 - blendValue) * 255 + blendValue * 0)
            
            // Convert RGB values to hex color string
            hexColor = String(format: "%02X%02X%02X", red, green, blue)
        }
        
        return hexColor
    }
    
    
    static func getColorFromValue(_ value: Double) -> Color {
        hexStringToColor(hex: getColorStrFromValue(value))
    }

    
    

    static var random: Color {
        Color(red: .random(in: 0 ... 255) / 255, green: .random(in: 0 ... 255) / 255, blue: .random(in: 0 ... 255) / 255)
    }

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
            typealias NativeColor = UIColor
        #elseif canImport(AppKit)
            typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }

    func getGradient(brightnessConstant: CGFloat? = nil) -> LinearGradient {
        LinearGradient(stops: [.init(color: self, location: 0.1), .init(color: getLighterColorForGradient(brightnessConstant), location: 2)], startPoint: .bottom, endPoint: .topLeading)
    }

    func getLighterColorForGradient(_ increaseAmount: CGFloat? = nil) -> Color {
        var b = components.blue * 255
        var r = components.red * 255
        var g = components.green * 255

        b += increaseAmount ?? 40
        r += increaseAmount ?? 40
        g += increaseAmount ?? 40

        if b > 255 { b = 255 }
        if r > 255 { r = 255 }
        if g > 255 { g = 255 }

        return Color(uiColor: .init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1))
    }

    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }

    static func hexStringToColor(hex: String) -> Color {
        Color(hexStringToUIColor(hex: hex))
    }

    /// This function uses the Color type's components() method to get the RGB (red, green, blue) values of the color, which are represented as floating-point values between 0 and 1. It then scales these values to the range 0-255, which is the standard range used for representing colors as hexadecimal values. Finally, it uses String(format:) to create a string in the format "#RRGGBB", where "RR", "GG", and "BB" are the hexadecimal values of the red, green, and blue components of the color, respectively.
    func getHex() -> String {
        let components = self.components
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
