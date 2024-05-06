//
//  String+HTML.swift
//  Crypro
//
//  Created by Beavean on 06.04.2024.
//

import Foundation

extension String {
    var removingHTMLOccurrences: String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
