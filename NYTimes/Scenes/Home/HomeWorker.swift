//
//  HomeWorker.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomeWorkerLogic {
    func doGetArticles(requestData: Home.GetArticles.Request, completed: @escaping ResponseDataCompletionHandler)
}

class HomeWorker: HomeWorkerLogic {
    var apiManager: APIManagerLogic = APIManager()
    func doGetArticles(requestData: Home.GetArticles.Request, completed: @escaping ResponseDataCompletionHandler) {
        var endpoint = ArticlesEndpoint.viewed1Day
        if requestData.period == .sevenDays {
            endpoint = ArticlesEndpoint.viewed7Days
        } else if requestData.period == .thirtyDays {
            endpoint = ArticlesEndpoint.viewed30Days
        }
        apiManager.sendJSONRequest(endpoint: endpoint, completion: {
            completed($0, $1)
        })
    }
}
