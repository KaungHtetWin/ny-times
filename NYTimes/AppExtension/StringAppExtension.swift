//
//  StringAppExtension.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }
    
    func displayPublicDate() -> String? {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: self)
        return date?.toString()
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
