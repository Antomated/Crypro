//
//  NetworkManager.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation
import Combine

final class NetworkManager {
    static func download(from endpoint: NetworkEndpoint) -> AnyPublisher<Data, Error> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidEndpoint).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        // Log the request
        print("Making request to \(url)")
        print("HTTP Method: \(request.httpMethod ?? "N/A")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.unknown
                }
                // Log the response status code
                print("Received response with status code: \(response.statusCode) from \(url)")
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.badURLResponse(url: url)
                }
                return output.data
            }
            .catch { error -> AnyPublisher<Data, Error> in
                // Log the error
                print("Error occurred: \(error.localizedDescription)")
                if (error as? NetworkError) == .badURLResponse(url: url) {
                    return Fail(error: NetworkError.retryLimitReached).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Request completed successfully.")
        case .failure(let error):
            print("Request failed with error: \(error.localizedDescription)")
        }
    }
}
