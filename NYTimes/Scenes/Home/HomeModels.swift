//
//  HomeModels.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

enum Home {
    // MARK: Use cases
    
    enum ArticlesPeriod: String, Codable {
        case oneDay
        case sevenDays
        case thirtyDays
    }
    
    enum GetArticles {
        struct Request: Codable {
            var period: ArticlesPeriod = .oneDay
        }
        
        struct Response: Codable {
            let status, copyright: String?
            let numResults: Int?
            let results: [Article]?
            let fault: Fault?
            enum CodingKeys: String, CodingKey {
                case status, copyright
                case numResults = "num_results"
                case results, fault
            }
        }
        
        struct ViewModel {
            let period: ArticlesPeriod
            let articles: [Article]?
        }
    }
}
