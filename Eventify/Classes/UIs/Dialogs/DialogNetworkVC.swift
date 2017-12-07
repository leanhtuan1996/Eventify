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
    }
}
