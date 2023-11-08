//
//  HomeRouter.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

@objc protocol HomeRoutingLogic {
  //func routeToSomewhere()
}

protocol HomeDataPassing {
  // var name: String? { set get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
  weak var viewController: HomeViewController?
  var name: String?
  // MARK: Routing
}
