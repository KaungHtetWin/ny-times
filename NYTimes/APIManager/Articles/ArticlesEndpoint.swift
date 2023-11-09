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
    case search(q: String)
    var httpMethod: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        default:
            return "https://api.nytimes.com/svc/"
        }
    }
    
    var path: String {
        switch self {
        case .viewed1Day:
            return "mostpopular/v2/viewed/1.json?api-key=B8pb9LcbrNNmXVOhGLxxUYnBUit7fCvB"
        case .viewed7Days:
            return "mostpopular/v2/viewed/7.json?api-key=B8pb9LcbrNNmXVOhGLxxUYnBUit7fCvB"
        case .viewed30Days:
            return "mostpopular/v2/viewed/30.json?api-key=B8pb9LcbrNNmXVOhGLxxUYnBUit7fCvB"
        case .search(let q):
            let encodedQuery = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "search/v2/articlesearch.json?q=\(encodedQuery)&api-key=B8pb9LcbrNNmXVOhGLxxUYnBUit7fCvB"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
}
