//
//  NetworkManager.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//

import Foundation
import Combine

final class NetworkManager {
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func download<T>(from endpoint: NetworkEndpoint,
                            convertTo type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidEndpoint).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                try handleURLResponse(output: output, url: url)
            }
            .catch { error -> AnyPublisher<Data, Error> in
                if (error as? NetworkError) == .badURLResponse(url: url) {
                    return Fail(error: NetworkError.retryLimitReached).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }

    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            print("no response or bad response")
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }

    // TODO: Improve
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Request completed successfully.")
        case .failure(let error):
            print("Request failed with error: \(error.localizedDescription)")
        }
    }
}
