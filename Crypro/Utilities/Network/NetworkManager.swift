//
//  NetworkManager.swift
//  Crypro
//
//  Created by Antomated on 02.04.2024.
//

import Combine
import Foundation

protocol NetworkManaging {
    func download<T: Decodable>(from endpoint: CoingeckoEndpoint, convertTo: T.Type) -> AnyPublisher<T, NetworkError>
    func download(url: URL) -> AnyPublisher<Data, Error>
}

final class NetworkManager: NetworkManaging {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func download<T>(from endpoint: CoingeckoEndpoint,
                     convertTo _: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let url = endpoint.url else {
            return Fail(error: .invalidEndpoint).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                try self.handleURLResponse(output: output, url: url)
            }
            .retry(3)
            .mapError { error in
                (error as? NetworkError) ?? .unknown
            }
            .decode(type: T.self, decoder: self.decoder)
            .mapError { _ in .decodingError }
            .eraseToAnyPublisher()
    }

    func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try self.handleURLResponse(output: $0, url: url) }
            .retry(3)
            .eraseToAnyPublisher()
    }

    private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }
}
