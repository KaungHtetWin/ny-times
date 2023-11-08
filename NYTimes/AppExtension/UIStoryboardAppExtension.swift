//
//  UIStoryboardAppExtension.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import Foundation
import UIKit
extension UIStoryboard {
    public enum StoryBoard: String {
        case Home = "Home"
        
        func instance(_ vc:String) -> UIViewController {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: vc)
        }
    }
    
     //MARK:- Home StoryBoard
    class func homeViewController() -> HomeViewController? {
        return StoryBoard.Home.instance(HomeViewController.className) as? HomeViewController
    }
}
