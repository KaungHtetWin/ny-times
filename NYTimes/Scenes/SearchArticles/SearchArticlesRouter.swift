//
//  SearchArticlesRouter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

@objc protocol SearchArticlesRoutingLogic {
    func routeToDetails()
}

protocol SearchArticlesDataPassing {
    // var name: String? { set get }
}

class SearchArticlesRouter: NSObject, SearchArticlesRoutingLogic, SearchArticlesDataPassing {
    weak var viewController: SearchArticlesViewController?
//    var name: String?
    // MARK: Routing
    func routeToDetails() {
        let destinationVC = UIStoryboard.articlesDetailsViewController()
        
        guard var destinationDS = destinationVC?.router?.dataStore,
              let selectedRow = viewController?.articleCollectionView.indexPathsForSelectedItems?.first?.row else {
            return
        }
        destinationDS.doc = viewController?.searchArticles[selectedRow]
        viewController?.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
