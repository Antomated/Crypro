//
//  String+HTML.swift
//  Crypro
//
//  Created by Anton Petrov on 06.04.2024.
//

import Foundation

extension String {
    var removingHTMLOccurrences: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
