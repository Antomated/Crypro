//
//  NetworkError.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//
// TODO: Localize

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badURLResponse(url: URL)
    case retryLimitReached
    case unknown
    case invalidEndpoint
    case decodingError

    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url): return "Bad response from URL: \(url)"
        case .retryLimitReached: return "Retry limit reached"
        case .unknown: return "Unknown error occurred"
        case .invalidEndpoint: return "Invalid endpoint"
        case .decodingError: return "Error decoding response"
        }
    }
}
