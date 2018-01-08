//
//  Extensions+UIActivityIndicatorView.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/17/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func showLoadingDialog() {
        self.activityIndicatorViewStyle = .whiteLarge
        self.color = UIColor.white
        
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {
            return
        }
        window.addSubview(self)
        self.frame = window.frame
        self.center = window.center
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        self.startAnimating()
    }
    
    func stopLoadingDialog() {
        self.stopAnimating()
    }
}
