//
//  Fonts.swift
//  Crypro
//
//  Created by Antomated on 20.06.2024.
//

import SwiftUI

extension Font {
    enum ChakraPetch: String {
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"

        var fontName: String {
            "ChakraPetch-" + rawValue
        }
    }

    static func chakraPetch(_ type: ChakraPetch, size: CGFloat = 26) -> Font {
        return .custom(type.fontName, size: size)
    }
}
