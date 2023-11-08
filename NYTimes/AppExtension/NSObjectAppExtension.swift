//
//  NSObjectAppExtension.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
