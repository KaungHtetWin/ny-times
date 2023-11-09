//
//  SearchArticlesInteractor.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol SearchArticlesBusinessLogic {
    func doGetSearchArticles(request: SearchArticles.Search.Request)
}

class SearchArticlesInteractor: SearchArticlesBusinessLogic {
    var presenter: SearchArticlesPresentationLogic?
    var worker: SearchArticlesWorkerLogic?
    
    init() {
        worker = SearchArticlesWorker()
    }
    func doGetSearchArticles(request: SearchArticles.Search.Request) {
        worker?.doSearchArticles(requestData: request, completed: {[weak self] (JSONObject, error) in
            if error == nil {
                if let response = SearchArticles.Search.Response.from(data: JSONObject) {
                    if let message = response.fault?.detail?.errorcode {
                        self?.presenter?.presentError(message: message)
                    } else {
                        self?.presenter?.presentSearchArticles(response: response)
                    }
                } else {
                    self?.presenter?.presentError(message: APIError.jsonSerializeError.localizedDescription)
                }
            } else {
                self?.presenter?.presentError(message: error?.localizedDescription ?? "")
            }
        })
    }
}
