//
//  NetworkServiceProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func download<T: Decodable>(from endpoint: CoingeckoEndpoint, convertTo: T.Type) -> AnyPublisher<T, NetworkError>
    func download(url: URL) -> AnyPublisher<Data, Error>
}
