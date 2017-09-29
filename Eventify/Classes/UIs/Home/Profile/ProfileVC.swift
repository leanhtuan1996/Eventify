//
//  ProfileVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = 50
        
//        imgBackground.image = imgAvatar.image
//        imgBackground.addBlurEffect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - ACTIONS

    @IBAction func btnEditAvatarClicked(_ sender: Any) {
    }
    
    @IBAction func btnEditPasswordClicked(_ sender: Any) {
    }
    
    @IBAction func btnEditFullNameClicked(_ sender: Any) {
    }
    
    
    @IBAction func btnEditEmail(_ sender: Any) {
    }
    
    @IBAction func editAvatarTapped(_ sender: Any) {
        print("aaa")
    }
    
    
}
