//
//  Extensions+UIActivityIndicatorView.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/17/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func showLoadingDialog(_ toVC: UIViewController) {
        self.activityIndicatorViewStyle = .whiteLarge
        self.color = UIColor.white
        toVC.tabBarController?.view.addSubview(self)
        //toVC.view.addSubview(self)
        self.frame = toVC.tabBarController?.view.bounds ?? toVC.view.bounds
        self.center = toVC.tabBarController?.view.center ?? toVC.view.center
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        self.startAnimating()
    }
    
    func stopLoadingDialog() {
        self.stopAnimating()
    }
}
