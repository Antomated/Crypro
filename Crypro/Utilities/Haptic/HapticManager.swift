//
//  HapticManager.swift
//  Crypro
//
//  Created by Beavean on 11.04.2024.
//

import SwiftUI

final class HapticManager {
    private static let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
