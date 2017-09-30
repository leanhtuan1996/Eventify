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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tblProfile: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserServices.shared.getInfomations { (user, error) in
            if let error = error {
                self.showAlert("Get infomations error: \(error)", title: "ERROR", buttons: nil)
                return
            }
            
            if let user = user {
                self.lblName.text = user.fullName
                self.lblEmail.text = user.email
                
            }
        }
    }
   

    // MARK: - ACTIONS

    @IBAction func btnEditProfileClicked(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
    @IBAction func btnTicketsClicked(_ sender: Any) {
    }
    
    @IBAction func btnSavedEventsClicked(_ sender: Any) {
    }
    
    
}
