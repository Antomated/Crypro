//
//  HapticManager.swift
//  Crypro
//
//  Created by Anton Petrov on 11.04.2024.
//
// TODO: Add more/refactor

import Foundation
import SwiftUI

class HapticManager {

    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
