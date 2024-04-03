//
//  Statistic.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?

    // TODO: Temporary

    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
