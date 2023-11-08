//
//  HomePresenter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomePresentationLogic {
    func presentHome(response: Home.GetArticles.Response)
    func presentError(message: String)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentHome(response: Home.GetArticles.Response) {
        let viewModel = Home.GetArticles.ViewModel(articles: response.results)
        viewController?.displayHome(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
