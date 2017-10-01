//
//  EditProfileVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = 50
        imgCover.image = imgAvatar.image
        imgCover.addBlurEffect()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: true)
        }
        
        //tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(false, animated: true)
        }
       
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdatePhotoClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdatePasswordClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdateEmailClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdatePhoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdateFullNameClicked(_ sender: Any) {
    }
    
    @IBAction func btnLogOutClicked(_ sender: Any) {
        let loading = UIActivityIndicatorView()
        loading.showLoadingDialog(self)
        UserServices.shared.signOut()
    }
}
