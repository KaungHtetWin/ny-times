//
//  ArticlesEndpoint.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation

enum ArticlesEndpoint: Endpoint {
    case viewed1Day
    case viewed7Days
    case viewed30Days
    var httpMethod: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        default:
            return "https://api.nytimes.com/svc/mostpopular/v2/"
        }
    }
    
    var path: String {
        switch self {
        case .viewed1Day:
            return "viewed/1.json"
        case .viewed7Days:
            return "viewed/7.json"
        case .viewed30Days:
            return "viewed/30.json"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "api-key": "B8pb9LcbrNNmXVOhGLxxUYnBUit7fCvB"]
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
}
