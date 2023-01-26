//
//  ExtDate.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation

extension DateComponents {
    func formattedTime() -> String {
        guard let hour = self.hour,
              let date = Calendar.current.date(bySettingHour: hour, minute: self.minute ?? 0, second: 0, of: .now) else {
            return ""
        }
        
        return date.getFormattedDate(format: .minimalTime)
    }
}

extension Date {
    static func beginningOfDay(_ day: Date = Date.now) -> Date {
        Date.getThisTime(hour: 0, minute: 0, second: 1, from: day)!
    }

    static func endOfDay(_ day: Date = Date.now) -> Date {
        Date.getThisTime(hour: 23, minute: 59, second: 59, from: day)!
    }

    static func getDayOfWeek(daysBack: Int) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let previousDay = calendar.date(byAdding: .day, value: -daysBack, to: currentDate)
        let dayOfWeek = calendar.component(.weekday, from: previousDay!)
        switch dayOfWeek {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tue"
            case 4:
                return "Wed"
            case 5:
                return "Thu"
            case 6:
                return "Fri"
            case 7:
                return "Sat"
            default:
                return "Invalid day"
        }
    }

    enum DateFormats: String, CustomStringConvertible {
        var description: String { rawValue }
        case minimalTime = "h:mm a"
        case abreviatedMonth = "MMM d, yyyy"
        case monthDay = "MMM d"
        case slashDate = "M/d/yyyy"
        case slashDateZeros = "MM/d/yyyy"
        case abreviatedMonthAndMinimalTime = "MMM d, yyyy h:mm a"
    }

    static func today() -> Date {
        return Date()
    }

    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next, weekday,
                   considerToday: considerToday)
    }

    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }

    func getDateComponents(components: Set<Calendar.Component> = [.hour, .minute]) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(components, from: self)
        return components
    }

    static func getSameTime(as thisDate: Date, forThisDay: Date) -> Date {
        let difference = thisDate - .getThisTime(hour: 0, minute: 0, from: thisDate)!
        return .getThisTime(hour: 0, minute: 0, from: forThisDay)!.advanced(by: difference)
    }

    func offsetFromZero() -> TimeInterval {
        return abs(self - .getThisTime(hour: 0, minute: 0, from: self)!)
    }

    func get(_ direction: SearchDirection, _ weekDay: Weekday, considerToday consider: Bool = false) -> Date {
        let dayName = weekDay.rawValue

        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

        let calendar = Calendar(identifier: .gregorian)

        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }

        var nextDateComponent = calendar.dateComponents([.hour,
                                                         .minute,
                                                         .second],
                                                        from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)

        return date!
    }

    func isSameDayAs(_ otherDate: Date) -> Bool {
        Calendar.current.compare(self, to: otherDate, toGranularity: .day) == .orderedSame ? true : false
    }

    static func datesFallOnSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.year, .month, .day], from: date1)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date2)
        return date1Components == date2Components
    }

    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }

    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
                case .next:
                    return .forward
                case .previous:
                    return .backward
            }
        }
    }

    /// Gets the time given the hour and minute for TODAY
    static func getThisTime(hour: Int, minute: Int, second: Int = 0, from date: Date = .now) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: date)
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.day = Calendar.current.component(.day, from: date)
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Create date from components
        return Calendar(identifier: .gregorian).date(from: dateComponents)
    }

    static let nineAM: Date = Date.getThisTime(hour: 9, minute: 0)!
    static let fivePM: Date = Date.getThisTime(hour: 17, minute: 0)!
    static let noon: Date = Date.getThisTime(hour: 12, minute: 0)!

    func getFormattedDate(format: String, amPMCapitalized: Bool = true) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.amSymbol = amPMCapitalized ? "AM" : "am"
        dateformat.pmSymbol = amPMCapitalized ? "PM" : "pm"
        return dateformat.string(from: self)
    }

    func getFormattedDate(format: DateFormats, amPMCapitalized: Bool = true) -> String {
        getFormattedDate(format: format.description,
                         amPMCapitalized: amPMCapitalized)
    }

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    var isDateInWeekend: Bool {
        return Calendar.iso8601.isDateInWeekend(self)
    }

    var tomorrow: Date {
        return Calendar.iso8601.date(byAdding: .day,
                                     value: 1,
                                     to: noon)!
    }

    var noon: Date {
        return Calendar.iso8601.date(bySettingHour: 12,
                                     minute: 0,
                                     second: 0,
                                     of: self)!
    }

    static func getDateFromString(_ str: String, format: String = "MM/dd/yyyy") -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format

        return dateFormatterGet.date(from: str)
    }

    static func dayTypes(from start: Date, to end: Date) -> (weekendDays: Int, workingDays: Int) {
        guard start < end else { return (0, 0) }
        var weekendDays = 0
        var workingDays = 0
        var date = start.noon
        repeat {
            if date.isDateInWeekend {
                weekendDays += 1
            } else {
                workingDays += 1
            }
            date = date.tomorrow
        } while date < end
        return (weekendDays, workingDays)
    }

    func addHours(_ hours: Double) -> Date {
        advanced(by: hours * 60 * 60)
    }

    func addMinutes(_ minutes: Double) -> Date {
        advanced(by: minutes * 60)
    }

    func addDays(_ days: Double) -> Date {
        addHours(days * 24)
    }

    static func secondsFormatted(_ seconds: Double, allowedUnits: NSCalendar.Unit = [.hour, .minute, .second], unitsStyle: DateComponentsFormatter.UnitsStyle = .abbreviated) -> String {
        let interval = seconds
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.unitsStyle = unitsStyle

        guard let formattedString = formatter.string(from: TimeInterval(interval)) else {
            return "SOMETHING WRONG"
        }
        return formattedString
    }

    static func formattedTimeString(_ seconds: Double) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
        return "\(h):\(m):\(s)"
    }

    static func secondsToHoursMinutesSeconds(_ seconds: Double) -> (Int, Int, Int) {
        return (Int(seconds) / 3_600, (Int(seconds) % 3_600) / 60, (Int(seconds) % 3_600) % 60)
    }

    static func secondsToHoursMinutes(_ seconds: Double) -> (Int, Int) {
        return (Int(seconds) / 3_600, (Int(seconds) % 3_600) / 60)
    }

    static func secToHM(_ sec: Double) -> (hours: Int, min: Int) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(sec))!
        let ls = formattedString.components(separatedBy: ":")

        let h = ls.count > 0 ? Int(ls[0]) ?? 0 : 0
        let m = ls.count > 1 ? Int(ls[1]) ?? 0 : 0

        return (hours: h, min: m)
    }

    static func secondsToHoursMinutesStr(_ seconds: Double) -> String {
        let (hours, min) = secToHM(seconds)
        let hrStr = "\(hours)"
        var minStr: String = "\(min)"
        if min < 10 {
            minStr = "0\(minStr)"
        }
        return hrStr + ":" + minStr
    }

    static func daysBetween(thisDate: Date, and: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: thisDate, to: and).day
    }
}

/// Get business days
extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}
