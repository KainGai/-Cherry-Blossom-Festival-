import Foundation
extension DateFormatter {
    class var eventScheduleJSONDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }
}
