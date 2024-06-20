//
//  Fonts.swift
//  Crypro
//
//  Created by Beavean on 20.06.2024.
//

import SwiftUI

extension Font {
    enum ChakraPetch: String {
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"

        var fontName: String {
            "ChakraPetch-" + self.rawValue
        }
    }

    static func chakraPetch(_ type: ChakraPetch, size: CGFloat = 26) -> Font {
        return .custom(type.fontName, size: size)
    }
}
