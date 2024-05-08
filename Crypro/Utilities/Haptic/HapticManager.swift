//
//  HapticManager.swift
//  Crypro
//
//  Created by Beavean on 11.04.2024.
//

import SwiftUI

struct HapticManager {
    private static let generator = UINotificationFeedbackGenerator()
    private static let selectionGenerator = UISelectionFeedbackGenerator()

    static func triggerNotification(ofType type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }

    static func triggerSelection() {
        selectionGenerator.selectionChanged()
    }
}
