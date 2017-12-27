//
//  Extensions+UIImageView.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Haneke

let stringCache = Shared.stringCache

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
    
    
    func downloadedFrom(url: URL, _ completionHandler: ((_ image: UIImage?, _ error: String?) -> Void)? = nil) {
        //self.hnk_setImageFromURL(url)
        hnk_setImageFromURL(url, placeholder: nil, format: nil, failure: { (error) in
            completionHandler?(nil, error?.localizedDescription)
        }) { (image) in
            self.image = image
            completionHandler?(image, nil)
        }
        
    }
    func downloadedFrom(link: String, _ completionHandler: ((_ image: UIImage?, _ error: String?) -> Void)? = nil) {
        
        guard let url = URL(string: link) else { completionHandler?(nil, "FAIL"); return }
        
        downloadedFrom(url: url) { (image, error) in
            completionHandler?(image, error)
        }
    }
    
    /*
    func downloadedFrom(path: String, _ completionHandler: ((_ image: UIImage?, _ error: String?) -> Void)? = nil ) {
        
        stringCache.fetch(key: path)
            .onSuccess { (string) in
                
                self.downloadedFrom(link: string, { (image, error) in
                    completionHandler?(image, error)
                })
                
            }.onFailure { (error) in
                EventServices.shared.downloadImageCover(withPath: path, completionHandler: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let url = url else {
                        return
                    }
                    
                    stringCache.set(value: String(describing: url), key: path)
                    
                    self.downloadedFrom(url: url, { (image, error) in
                        completionHandler?(image, error)
                    })
                })
        }
    }
    */
}
