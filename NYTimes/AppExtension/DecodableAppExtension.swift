//
//  DecodableAppExtension.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation

extension Decodable {
    static func from(data: Data?) -> Self? {
        let decoder = JSONDecoder()
        guard let jsonData = data else { return nil }
        do {
            return try decoder.decode(Self.self, from: jsonData)
        } catch let error {
            print("Decodable \(#function) \(error)")
            return nil
        }
    }
}
