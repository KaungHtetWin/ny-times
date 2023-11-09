//
//  HomeInteractor.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomeBusinessLogic {
    func doGetArticles(request: Home.GetArticles.Request)
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic?
    
    init() {
        worker =  HomeWorker()
    }
    
    func doGetArticles(request: Home.GetArticles.Request) {
        worker?.doGetArticles(requestData: request, completed: {[weak self] (JSONObject, error) in
            if error == nil {
                if let response = Home.GetArticles.Response.from(data: JSONObject) {
                    if let message = response.fault?.detail?.errorcode {
                        self?.presenter?.presentError(message: message)
                    } else {
                        self?.presenter?.presentArticles(response: response, period: request.period)
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
