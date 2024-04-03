//
//  UIApplication+EndEditing.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//
// TODO: Check Relevance

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
