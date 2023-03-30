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

    /// A utility function that formats a numeric value as a string representing a time interval in hours and minutes.
    ///
    /// - Parameter allowedUnits: An optional NSCalendar.Unit value specifying the units to use for formatting the time interval. The default value is [.hour, .minute].
    ///
    /// - Returns: A formatted string representation of the numeric value as a time interval.
    ///
    /// This function calls the secondsFormatted(_:allowedUnits:) class method of the Date class to format the numeric value as a string representing a time interval in hours and minutes. The allowedUnits parameter specifies the units to use for formatting the time interval. The default value is [.hour, .minute], which formats the time interval in hours and minutes only.

    /// The resulting string is then returned as the result of this function.
    func formatForTime(_ allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String {
        Date.secondsFormatted(self, allowedUnits: allowedUnits)
    }
    
    /// A utility function that formats a numeric value as a string representing a baseball statistic with three decimal places.
    ///
    /// - Returns: A formatted string representation of the numeric value as a baseball statistic.
    ///
    /// This function uses the roundTo(places:) method to round the numeric value to three decimal places, and then formats the rounded value as a string with three decimal places using the String(format:) initializer.

    /// If the formatted string starts with "0.", this function returns the string with the leading "0" removed. Otherwise, it returns the formatted string with three decimal places.

    /// The resulting string is then returned as the result of this function.
    func formatForBaseball() -> String {
        let formattedValue = String(format: "%.3f", self.roundTo(places: 3))
                if formattedValue.hasPrefix("0.") {
                    return String(formattedValue.dropFirst(1))
                }
                return formattedValue
    }

    /// A computed property that returns a string representation of the numeric value, with a trailing zero if the value is rounded to the nearest tenth but not to the nearest hundredth.
    ///
    /// - Returns: A string representation of the numeric value, with a trailing zero if applicable.
    ///
    /// This property first rounds the numeric value to the nearest tenth and the nearest hundredth using the roundTo(places:) method. It then compares the rounded values to see if they are equal.

    /// If the rounded values are equal, this property returns the string representation of the original numeric value with a trailing zero added. Otherwise, it returns the string representation of the original numeric value without a trailing zero.

    /// The resulting string is then returned as the result of this property.
    var str: String {
        let roundTens = roundTo(places: 1)
        let roundHundreds = roundTo(places: 2)
        if roundTens == roundHundreds {
            return "\(self)0"
        }
        return "\(self)"
    }

    /// A utility function that returns a string representation of the numeric value, with an optional trailing zero.
    ///
    /// - Parameter includeSecondZero: A boolean value indicating whether or not to include a trailing zero when the value is rounded to the nearest tenth but not to the nearest hundredth. The default value is false.
    ///
    /// - Returns: A string representation of the numeric value, with an optional trailing zero.
    ///
    /// This function first rounds the numeric value to the nearest tenth and the nearest hundredth using the roundTo(places:) method. It then compares the rounded values to see if they are equal.

    /// If includeSecondZero is true and the rounded values are equal, this function returns the string representation of the original numeric value with a trailing zero added. Otherwise, it returns the string representation of the original numeric value without a trailing zero.

    /// The resulting string is then returned as the result of this function.
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

    func simpleStr(_ places: Int = 1, _ removeFrontZero: Bool = false) -> String {
        let rounded = roundTo(places: places)
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            
            
            
            return String(Int(rounded))
        } else {
            
            if removeFrontZero {
                let split = String(rounded).components(separatedBy: ".")
                if let back = split.safeGet(at: 1) {
                    return "." + back
                }
                return String(rounded)
            }
            
            return String(rounded)
        }
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
