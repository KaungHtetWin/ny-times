//
//  ArticlesDetailsModels.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

enum ArticleDetails {
    // MARK: Use cases
    
    enum Get {
        struct Request {
        }
        
        struct Response {
            let article: Article?
            let doc: Doc?
        }
        
        struct ViewModel {
            let article: Article?
            let doc: Doc?
        }
    }
}
