//
//  AppUtility.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation

struct AppUtility {
    static func readLocalFile(forName name: String) -> Data? {
        do {
            let bundlePath = Bundle.main.path(forResource: name, ofType: "json") ?? ""
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            return jsonData
        } catch {
            return nil
        }
    }
}
