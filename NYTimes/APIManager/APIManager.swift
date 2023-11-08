//
//  APIManager.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation
typealias ResponseDataCompletionHandler = (_ JSONObject: Data?, _ error: Error?) -> Void

protocol APIManagerLogic {
    func sendJSONRequest(endpoint: Endpoint, completion : @escaping (ResponseDataCompletionHandler))
}

class APIManager: APIManagerLogic {
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func sendJSONRequest(endpoint: Endpoint, completion : @escaping (ResponseDataCompletionHandler)) {
        guard let url = URL(string: endpoint.url) else {
            completion(nil, APIError.URLNotFound)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpMethod = endpoint.httpMethod
        urlRequest.httpBody = endpoint.body
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, repsonse, error) in
            if error != nil {
                completion(nil, error)
            } else {
                let url = (repsonse as? HTTPURLResponse)?.url?.absoluteString ?? ""
                print(url)
                completion(data, nil)
            }
        })
        
        task.resume()
    }
}

enum APIError: Equatable, Error {
    case jsonSerializeError
    case URLNotFound
    case ServerError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .URLNotFound:
            return NSLocalizedString("URL Not Found", comment: "")
        case .jsonSerializeError:
            return NSLocalizedString("Json Serialize Error", comment: "")
        case .ServerError:
            return NSLocalizedString("Server Error", comment: "")
        }
    }
}
