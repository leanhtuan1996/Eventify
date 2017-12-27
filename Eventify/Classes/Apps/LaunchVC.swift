//
//  LaunchVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            SocketIOServices.shared.establishConnection(completionHandler: { (error) in
                if error == nil {
                    UserManager.shared.verifyToken({ (error) in
                        self.hideVC(appDelegate, error)
                    })
                } else {
                    self.hideVC(appDelegate, error)
                }
            })
        }
    }
    
    func hideVC(_ appDelegate: AppDelegate, _ error: String?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .curveLinear], animations: {
            self.imgLogo.transform = CGAffineTransform(scaleX: 10, y: 10)
            self.imgLogo.backgroundColor = UIColor.clear.withAlphaComponent(1)
        }) { (finish) in
            if error != nil {
                appDelegate.showSignInView()
            } else {
                appDelegate.showMainView()
            }
        }
    }
    
    
}
