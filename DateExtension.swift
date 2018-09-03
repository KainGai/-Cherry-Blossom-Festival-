import Foundation
extension Date {
    private static var scheduleDateFormatter: ScheduleDateFormatter {
        return ScheduleDateFormatter(dateFormat: "yyyy-MM-dd")
    }
    static func scheduleDate(_ scheduleDate: ScheduleDate) -> Date {
        let dateString = scheduleDate.rawValue
        return Date.scheduleDateFormatter.date(from: dateString)!
    }
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
        return dateFormatter.string(from: self)
    }
    static var jan1st2017: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
        return dateFormatter.date(from: "2017-01-01")!
    }
    func isLater(than date: Date) -> Bool {
        return self > date
    }
}
