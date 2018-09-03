import Foundation
extension NSPredicate {
    convenience init(from startScheduleDate: ScheduleDate, to endScheduleDate: ScheduleDate) {
        self.init(format: "startAt >= %@ && endAt < %@", startScheduleDate.date as NSDate, endScheduleDate.date as NSDate)
    }
}
