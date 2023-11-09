//
//  HomePresenter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomePresentationLogic {
    func presentArticles(response: Home.GetArticles.Response, period: Home.ArticlesPeriod)
    func presentError(message: String)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentArticles(response: Home.GetArticles.Response, period: Home.ArticlesPeriod) {
        let viewModel = Home.GetArticles.ViewModel(period: period, articles: response.results)
        viewController?.displayArticles(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
