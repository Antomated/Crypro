//
//  NetworkManagerProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Combine
import Foundation

protocol NetworkManagerProtocol {
    func download<T: Decodable>(from endpoint: APIEndpoint, convertTo: T.Type) -> AnyPublisher<T, NetworkError>
    func download(url: URL) -> AnyPublisher<Data, Error>
}
