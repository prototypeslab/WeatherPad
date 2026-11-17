
import Foundation

class Clock {
    
    static let dateFormatter = DateFormatter()
    static var flick: Bool = false

    static func currentDateString() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        var now = ""
        if flick {
            flick = false
            now = String(format:"%02d", hour) + ":" + String(format:"%02d", minute)
        } else {
            flick = true
            now = String(format:"%02d", hour) + " " + String(format:"%02d", minute)
        }
        
        return now
    }
    
    static func currentDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "EEEE, MMMM d" // 금요일, 6월 14 or Friday, June 14
        return dateFormatter.string(from: Date())
    }
}
