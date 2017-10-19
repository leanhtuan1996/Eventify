//
//  Extensions+UIImageView.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Haneke

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    
    func downloadedFrom(url: URL) {
        self.hnk_setImageFromURL(url)
        
    }
    func downloadedFrom(link: String) {
        
        guard let url = URL(string: link) else { return }
       
        downloadedFrom(url: url)
    }
    
    func downloadedFrom(path: String) {
        EventServicesTest.shared.downloadImageCover(withPath: path, completionHandler: { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = url else {
                return
            }
            self.downloadedFrom(url: url)
        })
    }
    
}
