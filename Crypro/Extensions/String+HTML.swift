//
//  String+HTML.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//
// TODO: Check for proper parsing

import Foundation

extension String {
    var removingHTMLOccurrences: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
