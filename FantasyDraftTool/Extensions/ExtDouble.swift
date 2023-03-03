//
//  ExtDouble.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation

extension Data {
    func byteCount() -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useBytes]
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(count))
    }
}

extension NSCalendar.Unit {
    static let hourMinuteSecond: NSCalendar.Unit = [.hour, .minute, .second]
    static let dayHourMinuteSecond: NSCalendar.Unit = [.day, .hour, .minute, .second]
    static let dayHourMinute: NSCalendar.Unit = [.day, .hour, .minute]
}

extension Double {
    /// Formats for money.
    /// - Parameter includeCents: default is true
    /// - Returns: Amount formatted including the dollar sign
    func formattedForMoney(includeCents: Bool = true) -> String {
        func cleanDollarAmount(amount: String) -> String {
            let dollarAmount = amount.trimmingCharacters(in: ["$"])
            if dollarAmount.isEmpty {
                return "$0"
            } else if dollarAmount.hasSuffix(".00") {
                return "$" + dollarAmount.replacingOccurrences(of: ".00", with: "")
            } else {
                return "$" + dollarAmount
            }
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency

        if let formattedValue = formatter.string(from: self as NSNumber) {
            let retVal = includeCents ? formattedValue : formattedValue.removeAllAfter(".")
            return cleanDollarAmount(amount: retVal)
        }

        return "\(self)"
    }

    func formattedForMoneyExtended(decimalPlaces: Int = 4) -> String {
        guard let currencySymbol = Locale.current.currencySymbol,
              let unicodeScalar = Unicode.Scalar(currencySymbol.unicodeScalars.first?.value ?? 36) else { return "" }
        func cleanDollarAmount(amount: String, decimals: Int) -> String {
            var decimalPlaces = decimals
            let dollarAmount = amount.trimmingCharacters(in: [unicodeScalar])
            if dollarAmount.isEmpty {
                return "$0"
            } else {
                var roundedAmount = String(format: "%.\(decimalPlaces)f", Double(dollarAmount) ?? 0.0)
                while roundedAmount.hasSuffix("0") && decimalPlaces < 11 {
                    decimalPlaces += 1
                    roundedAmount = String(format: "%.\(decimalPlaces)f", Double(dollarAmount) ?? 0.0)
                }
                func decimalSubstring(amount: String) -> String {
                    let parts = amount.split(separator: ".")
                    if parts.count == 2 {
                        return String(parts[1])
                    } else {
                        return ""
                    }
                }
                func integerSubstring(amount: String) -> String {
                    let parts = amount.split(separator: ".")
                    if parts.count >= 1 {
                        return String(parts[0])
                    } else {
                        return ""
                    }
                }

                var retVar: String

                if roundedAmount.hasSuffix(".00") {
                    retVar = "$" + roundedAmount.replacingOccurrences(of: ".00", with: "")
                } else {
                    retVar = "$" + roundedAmount
                }

                var strFollowingDecimal = decimalSubstring(amount: retVar)
                let strBeforeDecimal = integerSubstring(amount: retVar)

                while strFollowingDecimal.count > 2 && strFollowingDecimal.hasSuffix("0") {
                    _ = strFollowingDecimal.popLast()
                }

                return strBeforeDecimal + "." + strFollowingDecimal
            }
        }

//        if rounded == roundTo(places: 1) {
//            return dollarType ?? "" + "\(rounded)" + "0"
//        }
        return cleanDollarAmount(amount: currencySymbol + "\(self)", decimals: decimalPlaces)
    }

    func formatForTime(_ allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String {
        Date.secondsFormatted(self, allowedUnits: allowedUnits)
    }

    var str: String {
        let roundTens = roundTo(places: 1)
        let roundHundreds = roundTo(places: 2)
        if roundTens == roundHundreds {
            return "\(self)0"
        }
        return "\(self)"
    }

    func str(includeSecondZero: Bool = false) -> String {
        let roundTens = roundTo(places: 1)
        let roundHundreds = roundTo(places: 2)
        if roundTens == roundHundreds,
           includeSecondZero {
            return "\(self)0"
        }
        return "\(self)"
    }

    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension TimeInterval {
    var unitsStyle: DateComponentsFormatter.UnitsStyle {
        if self < 60 {
            return .abbreviated
        }
        if self < 60 * 60 && truncatingRemainder(dividingBy: 60) == 0 {
            return .abbreviated
        }
        return .positional
    }
}
