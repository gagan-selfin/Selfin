
import Foundation

public func timeAgoSince(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

    if let year = components.year, year >= 2 {
        return "\(year) yr"
    }

    if let year = components.year, year >= 1 {
        return "last year"
    }

    if let month = components.month, month >= 2 {
        return "\(month) months"
    }

    if let month = components.month, month >= 1 {
        return "last month"
    }

    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks"
    }

    if let week = components.weekOfYear, week >= 1 {
        return "last week"
    }

    if let day = components.day, day >= 2 {
        return "\(day) days"
    }

    if let day = components.day, day >= 1 {
        return "yesterday"
    }

    if let hour = components.hour, hour >= 2 {
        return "\(hour) hr"
    }

    if let hour = components.hour, hour >= 1 {
        return "an hr"
    }

    if let minute = components.minute, minute >= 2 {
        return "\(minute) min"
    }

    if let minute = components.minute, minute >= 1 {
        return "a min"
    }

    if let second = components.second, second >= 3 {
        return "\(second) s"
    }

    return "now"
}
