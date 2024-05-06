//
//  HapticManager.swift
//  Crypro
//
//  Created by Anton Petrov on 11.04.2024.
//

import Foundation
import SwiftUI

final class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
