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
    var user: UserObject?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tblProfile: UITableView!
    let loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = UserManager.shared.currentUser {
            lblName.text = user.fullName
            lblEmail.text = user.email
            
            if let photoUrl = user.photoDisplayPath {
                self.imgAvatar.downloadedFrom(link: photoUrl)
            } else {
                self.imgAvatar.image = #imageLiteral(resourceName: "avatar")
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
