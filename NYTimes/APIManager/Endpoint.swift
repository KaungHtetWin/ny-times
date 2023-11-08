//
//  Endpoint.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation

protocol Endpoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}
