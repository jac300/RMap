import Foundation

class DateFormats {

    static let shortFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    static let longFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()
}
