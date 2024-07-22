//
//  LogConfiguration.swift
//  Crypro
//
//  Created by Antomated on 31.05.2024.
//

import Foundation

enum LogConfiguration {
    case always
    case debugOnly
    case environmentVariable(String)

    var isEnabled: Bool {
        switch self {
        case .always:
            return true
        case .debugOnly:
            #if DEBUG
                return true
            #else
                return false
            #endif
        case let .environmentVariable(key):
            return ProcessInfo.processInfo.environment[key] == "YES"
        }
    }
}
