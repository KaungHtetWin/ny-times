//
//  SearchArticlesModels.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

enum SearchArticles {
    // MARK: Use cases
    
    enum Search {
        struct Request: Codable {
            let q: String
        }
        struct Response: Codable {
            let status, copyright: String?
            let searchResponse: SearchResponse?
            let fault: Fault?
            enum CodingKeys: String, CodingKey {
                case status, copyright
                case searchResponse = "response"
                case fault
            }
        }
        
        // MARK: - Response
        struct SearchResponse: Codable {
            let docs: [Doc]?
            let meta: Meta?
        }
        
        struct ViewModel {
            let docs: [Doc]?
        }
    }
}
