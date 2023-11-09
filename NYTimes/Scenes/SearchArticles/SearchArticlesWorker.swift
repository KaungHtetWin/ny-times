//
//  SearchArticlesWorker.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol SearchArticlesWorkerLogic {
    func doSearchArticles(requestData: SearchArticles.Search.Request, completed: @escaping ResponseDataCompletionHandler)
}

class SearchArticlesWorker: SearchArticlesWorkerLogic {
    var apiManager: APIManagerLogic = APIManager()
    func doSearchArticles(requestData: SearchArticles.Search.Request, completed: @escaping ResponseDataCompletionHandler) {
        let endpoint = ArticlesEndpoint.search(q: requestData.q)
        apiManager.sendJSONRequest(endpoint: endpoint, completion: {
            completed($0, $1)
        })
    }
}
