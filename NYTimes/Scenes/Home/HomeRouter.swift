//
//  HomeRouter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func routeToDetails()
}

protocol HomeDataPassing {
//     var article: Article? { set get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
//    var article: Article?
    // MARK: Routing
    func routeToDetails() {
        let destinationVC = UIStoryboard.articlesDetailsViewController()
        
        guard var destinationDS = destinationVC?.router?.dataStore,
              let selectedRow = viewController?.articleCollectionView.indexPathsForSelectedItems?.first?.row,
              let selectedSection = viewController?.articleCollectionView.indexPathsForSelectedItems?.first?.section else {
            return
        }
        if selectedSection == 0 {
            destinationDS.article = viewController?.viewed1Day[selectedRow]
        } else if selectedSection == 1 {
            destinationDS.article = viewController?.viewed7Days[selectedRow]
        }   else {
            destinationDS.article = viewController?.viewed30Days[selectedRow]
        }
        viewController?.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
