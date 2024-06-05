//
//  Statistic.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let percentageChange: Double?

    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
