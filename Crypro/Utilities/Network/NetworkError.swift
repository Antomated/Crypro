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
        case .badURLResponse(url: let url): return LocalizationKey.badResponseFromUrlError.localizedString + "\(url)"
        case .retryLimitReached: return LocalizationKey.retryLimitReachedError.localizedString
        case .unknown: return LocalizationKey.unknownErrorOccurredError.localizedString
        case .invalidEndpoint: return LocalizationKey.invalidEndpointError.localizedString
        case .decodingError: return LocalizationKey.decodingResponseError.localizedString
        }
    }
}
