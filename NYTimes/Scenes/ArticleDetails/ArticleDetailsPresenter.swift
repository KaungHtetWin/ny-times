//
//  ArticlesDetailsPresenter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol ArticleDetailsPresentationLogic {
    func presentArticleDetails(response: ArticleDetails.Get.Response)
}

class ArticleDetailsPresenter: ArticleDetailsPresentationLogic {
    weak var viewController: ArticleDetailsDisplayLogic?
    
    func presentArticleDetails(response: ArticleDetails.Get.Response) {
        let viewModel = ArticleDetails.Get.ViewModel(article: response.article, doc: response.doc)
        viewController?.displayArticleDetails(viewModel: viewModel)
    }
}
