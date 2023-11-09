//
//  SearchArticlesPresenter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol SearchArticlesPresentationLogic {
    func presentSearchArticles(response: SearchArticles.Search.Response)
    func presentError(message: String)
}

class SearchArticlesPresenter: SearchArticlesPresentationLogic {
    weak var viewController: SearchArticlesDisplayLogic?
    
    func presentSearchArticles(response: SearchArticles.Search.Response) {
        let viewModel = SearchArticles.Search.ViewModel(docs: response.searchResponse?.docs)
        viewController?.displaySearchArticles(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
