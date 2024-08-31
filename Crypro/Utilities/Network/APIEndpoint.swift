//
//  APIEndpoint.swift
//  Crypro
//
//  Created by Antomated on 31.08.2024.
//

import Foundation

protocol APIEndpoint {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
}
