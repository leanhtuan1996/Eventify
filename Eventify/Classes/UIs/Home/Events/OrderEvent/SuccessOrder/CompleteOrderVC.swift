//
//  SuccessOrderVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/5/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class CompleteOrderVC: UIViewController {
    @IBOutlet weak var btnDiscoverEvents: UIButton!
    @IBOutlet weak var btnViewTickets: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnDiscoverEvents.layer.cornerRadius = 10
        btnViewTickets.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        
        let done = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.backToDiscovery))
        self.navigationItem.setLeftBarButton(done, animated: true)
        
    }

    @IBAction func btnDiscoverEvents(_ sender: Any) {
        backToDiscovery()
    }
    @IBAction func btnViewTickets(_ sender: Any) {
        
    }
    
    func backToDiscovery() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
