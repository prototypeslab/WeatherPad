
import Foundation

enum LogEvent: String {
  
    case e = "🔴 Error   : " // error
    case i = "🟢 Info    : " // info
    case d = "🔵 Debug   : " // debug
    case v = "⚪️ Verbose : " // verbose
    case w = "🟠 Warning : " // warning
    case s = "⭕️ Severe  : " // severe
    

}


func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

class Log {
    
    static var dateFormat = "hh:mm:ss.SSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    
    /*
    05:04:03.201 ⚪️ Verbose : line:    58 : AppDelegate.swift        : verbose The application has finished launching.
    05:04:03.201 🟢 Debug   : line:    59 : AppDelegate.swift        : debug The application has finished launching.
    05:04:03.201 🔵 Info    : line:    60 : AppDelegate.swift        : info The application has finished launching.
    05:04:03.201 🟡 Warning : line:    61 : AppDelegate.swift        : warning The application has finished launching.
    05:04:03.201 🔴 Error   : line:    62 : AppDelegate.swift        : error The application has finished launching.
     
    04:58:35738 [🔵][ContentView.swift]:28 14 init() -> DEBUG
    04:58:35738 [🔴][ContentView.swift]:29 15 init() -> ERROR
    04:58:35738 [🟢][ContentView.swift]:30 14 init() -> INFO
    04:58:35738 [⚪️][ContentView.swift]:31 14 init() -> VERBOSE
    04:58:35738 [🟠][ContentView.swift]:32 14 init() -> WARNING
    04:58:35738 [⭕️][ContentView.swift]:33 14 init() -> SEVERE
    04:58:35738 [🔵][ContentView.swift]:36 14 init() -> Student(name: "Socket", rollNum: 19)

    */
    class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.e.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }

    
    class func i ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.i.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }
    
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.d.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }
    
    class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.v.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }
    
    class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.w.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }
    
    class func s( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            let logEventValue = LogEvent.s.rawValue
            let fileNameString = "\(sourceFileName(filePath: filename))"
            let filePaddedString = fileNameString.leftJustifiedLogger(toLength: 25,truncate: true, paddingString: " ")
            let lineNumber = "\(line)"
            let linePaddingString = lineNumber.rightJustifiedLogger(toLength: 5,truncate: true, paddingString: " ")
            print("\(Date().toString()) \(logEventValue)line: \(linePaddingString) : \(filePaddedString): \(object)")
        }
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
internal extension String {
    
    func leftJustifiedLogger(toLength: Int, truncate: Bool = false, paddingString: String) -> String {
        guard toLength > count else {
            return truncate ? String(prefix(toLength)) : self
        }
        return self + String(repeating: paddingString, count: toLength - count)
    }
    func rightJustifiedLogger(toLength: Int, truncate: Bool = false, paddingString: String) -> String {
        guard toLength > count else {
            return truncate ? String(suffix(toLength)) : self
        }
        return String(repeating: paddingString, count: toLength - count) + self
    }
}
