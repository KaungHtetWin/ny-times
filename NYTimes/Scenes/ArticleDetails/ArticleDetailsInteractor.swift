//
//  ArticlesDetailsInteractor.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol ArticleDetailsBusinessLogic {
    func doGetArticleDetails(request: ArticleDetails.Get.Request)
}

protocol ShowArticleDataStore {
    var article: Article? { get set }
    var doc: Doc? { get set }
}

class ArticleDetailsInteractor: ArticleDetailsBusinessLogic, ShowArticleDataStore {
    var doc: Doc?
    var article: Article?
    var presenter: ArticleDetailsPresentationLogic?
    
    func doGetArticleDetails(request: ArticleDetails.Get.Request) {
        if let article = article {
            presenter?.presentArticleDetails(response: ArticleDetails.Get.Response(article: article, doc: nil))
        }
        if let doc = doc {
            presenter?.presentArticleDetails(response: ArticleDetails.Get.Response(article: nil, doc: doc))
        }
    }
}
