//
//  NetworkManager.swift
//  Crypro
//
//  Created by Beavean on 02.04.2024.
//

import Combine
import Foundation

final class NetworkManager {
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func download<T>(from endpoint: CoingeckoEndpoint,
                            convertTo _: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let url = endpoint.url else {
            return Fail(error: .invalidEndpoint).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                try handleURLResponse(output: output, url: url)
            }
            .retry(3)
            .mapError { error in
                (error as? NetworkError) ?? .unknown
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { _ in .decodingError }
            .eraseToAnyPublisher()
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .retry(3)
            .eraseToAnyPublisher()
    }

    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }
}
