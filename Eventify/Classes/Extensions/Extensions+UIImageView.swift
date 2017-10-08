//
//  Extensions+UIImageView.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

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
    
    
    func downloadedFrom(url: URL ) {
        
        if let cacheImage = cacheImageCoverEvent.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cacheImage
            print("Image cached")
        } else {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    print("Image no cached")
                    self.image = image
                    cacheImageCoverEvent.setObject(image, forKey: url.absoluteString as NSString)
                }
                }.resume()
        }
    }
    func downloadedFrom(link: String) {
        
        guard let url = URL(string: link) else { return }
       
        downloadedFrom(url: url)
    }
    
}
