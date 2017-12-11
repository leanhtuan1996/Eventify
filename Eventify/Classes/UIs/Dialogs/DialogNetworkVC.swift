//
//  DialogNetworkVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DialogNetworkVC: UIViewController {

    @IBOutlet weak var viewDialog: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
        viewDialog.layer.cornerRadius = 5
        self.viewDialog.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.viewDialog.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: { 
            self.viewDialog.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: nil)
    }
}
