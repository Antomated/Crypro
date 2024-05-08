//
//  LogTag.swift
//  Crypro
//
//  Created by Anton Petrov on 08.05.2024.
//

import OSLog

enum LogTag: String {
    case error
    case warning
    case success
    case debug
    case network
    case simOnly

    var label: String {
        switch self {
        case .error:
            "[ERROR 🔴]"
        case .warning:
            "[WARNING 🟠]"
        case .success:
            "[SUCCESS 🟢]"
        case .debug:
            "[DEBUG 🔵]"
        case .network:
            "[NETWORK 🛜]"
        case .simOnly:
            "[SIMULATOR ONLY 📵]"
        }
    }

    var osLogType: OSLogType {
        switch self {
        case .error:
            .error
        case .warning:
            .fault
        case .success, .network, .simOnly:
            .info
        case .debug:
            .debug
        }
    }
}
