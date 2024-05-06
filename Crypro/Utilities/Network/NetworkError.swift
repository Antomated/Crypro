//
//  NetworkError.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badURLResponse(url: URL)
    case retryLimitReached
    case unknown
    case invalidEndpoint
    case decodingError

    var errorDescription: String? {
        switch self {
        case let .badURLResponse(url: url): return LocalizationKey.badResponseFromUrlError.localizedString + "\(url)"
        case .retryLimitReached: return LocalizationKey.retryLimitReachedError.localizedString
        case .unknown: return LocalizationKey.unknownErrorOccurredError.localizedString
        case .invalidEndpoint: return LocalizationKey.invalidEndpointError.localizedString
        case .decodingError: return LocalizationKey.decodingResponseError.localizedString
        }
    }
}
