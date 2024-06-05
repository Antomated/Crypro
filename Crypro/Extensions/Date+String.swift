//
//  Date+String.swift
//  Crypro
//
//  Created by Beavean on 12.04.2024.
//

import Foundation

extension Date {
    var shortDateString: String {
        Date.shortFormatter.string(from: self)
    }

    init?(dateString: String) {
        guard let date = Date.iso8601Formatter.date(from: dateString) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }

    private static var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }

    private static var iso8601Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}
