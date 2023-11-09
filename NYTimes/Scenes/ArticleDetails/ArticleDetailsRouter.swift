//
//  ArticlesDetailsRouter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

@objc protocol ArticleDetailsRoutingLogic {
    //func routeToSomewhere()
}

protocol ArticleDetailsDataPassing {
    var dataStore: ShowArticleDataStore? { set get }
}

class ArticleDetailsRouter: NSObject, ArticleDetailsRoutingLogic, ArticleDetailsDataPassing {
    weak var viewController: ArticleDetailsViewController?
    var dataStore: ShowArticleDataStore?
    // MARK: Routing
}
