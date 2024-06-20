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
        case let .badURLResponse(url: url):
            LocalizationKey.badResponseFromURLError.localizedString + "\(url)"
        case .retryLimitReached:
            LocalizationKey.retryLimitReachedError.localizedString
        case .unknown:
            LocalizationKey.unknownErrorOccurredError.localizedString
        case .invalidEndpoint:
            LocalizationKey.invalidEndpointError.localizedString
        case .decodingError:
            LocalizationKey.decodingResponseError.localizedString
        }
    }
}
