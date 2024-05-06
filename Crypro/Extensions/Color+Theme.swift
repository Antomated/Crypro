//
//  Color+Theme.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let accent = Color(.accent)
    let background = Color(.background)
    let black = Color(.black)
    let secondaryText = Color(.secondaryText)
    let red = Color(.accentRed)
    let green = Color(.accentGreen)
}

struct LaunchTheme {
    let accent = Color(.accent)
    let background = Color(.launchBackground)
}
