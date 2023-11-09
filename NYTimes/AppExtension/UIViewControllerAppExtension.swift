//
//  UIViewControllerAppExtension.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = "Error", message: String?, actionText: String? = "Okay", actionCallback: (() -> Void)? = nil) {
        
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.message = message
            currentAlert.title = title
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: actionText, style: .default, handler: { (_) in
            actionCallback?()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading(for reason: String = "Please Wait") {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let safeFrame = keyWindow?.frame else { return }
        let darkBGView = getLoaderDarkBG()
        darkBGView.frame = safeFrame
        
        let loaderViewWidth = safeFrame.width - 80
        let loaderMsg = getLoaderMsg(with: reason)
        let loaderMsgWidth = loaderViewWidth - 70 - 10
        loaderMsg.frame = CGRect(x: 70, y: 5, width: loaderMsgWidth, height: 50)
        loaderMsg.sizeToFit()
        loaderMsg.frame.size.height = loaderMsg.frame.height < 50 ? 50 : loaderMsg.frame.height
        loaderMsg.frame = CGRect(x: 70, y: 5, width: loaderMsgWidth, height: loaderMsg.frame.height)
        
        let loader = getLoader()
        let loaderYPos = ((loaderMsg.frame.height - 50) / 2) + 5
        loader.frame = CGRect(x: 10, y: loaderYPos, width: 50, height: 50)
        
        let loaderViewHeight = loaderMsg.frame.height + 10
        let loaderViewYPos = (safeFrame.height - loaderViewHeight) / 2
        let loaderView = getLoaderView()
        loaderView.frame = CGRect(x: 40, y: loaderViewYPos, width: loaderViewWidth, height: loaderViewHeight)
        loaderView.layer.cornerRadius = 8
        loaderView.layer.masksToBounds = true
        
        loaderView.addSubview(loader)
        loaderView.addSubview(loaderMsg)
        
        keyWindow?.addSubview(darkBGView)
        keyWindow?.addSubview(loaderView)
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            keyWindow?.viewWithTag(9999)?.removeFromSuperview()
            keyWindow?.viewWithTag(9998)?.removeFromSuperview()
            completion?()
        }
    }
    
    private func getLoaderDarkBG() -> UIView {
        let bgView = UIView()
        bgView.tag = 9999
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return bgView
    }
    
    private func getLoaderView() -> UIView {
        let loaderView = UIView()
        loaderView.tag = 9998
        loaderView.backgroundColor = UIColor.white
        return loaderView
    }
    
    private func getLoader() -> UIActivityIndicatorView {
        let loader = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loader.hidesWhenStopped = true
        loader.style = .medium
        loader.startAnimating()
        return loader
    }
    
    private func getLoaderMsg(with title: String) -> UILabel {
        let msgLabel = UILabel()
        msgLabel.text = title
        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = .byWordWrapping
        msgLabel.textColor = UIColor.black
        return msgLabel
    }
}
