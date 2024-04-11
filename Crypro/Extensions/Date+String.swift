//
//  Date+String.swift
//  Crypro
//
//  Created by Anton Petrov on 12.04.2024.
//
// TODO: Check for convenient formatting

import Foundation

extension Date {
    init(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: dateString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }

    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }

    func asShortDateString() -> String {
        shortFormatter.string(from: self)
    }
}
