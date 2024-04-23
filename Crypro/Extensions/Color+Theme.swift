//
//  Color.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//
// TODO: Consider refactor into assets

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let accent = Color(.accent)
    let background = Color(.background)
    let secondaryText = Color(.secondaryText)
    let red = Color(uiColor: #colorLiteral(red: 0.7570628524, green: 0.05705995113, blue: 0.1604398489, alpha: 1))
    let green = Color(uiColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
}

struct LaunchTheme {
    let accent = Color(.accent)
    let background = Color(.launchBackground)
}
