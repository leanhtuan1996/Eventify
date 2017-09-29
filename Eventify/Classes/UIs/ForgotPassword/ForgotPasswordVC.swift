//
//  ForgotPasswordVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let activityIndicatorView = UIActivityIndicatorView()
    let appDelegate = UIApplication.shared.delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Email textfield
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 5
        txtEmail.backgroundColor = UIColor.clear
        txtEmail.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.textColor = UIColor.white
        txtEmail.becomeFirstResponder()
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Done button
        btnDone.layer.cornerRadius = 10
    }

    @IBAction func btnDone(_ sender: Any) {
        //if Email
        if !txtEmail.hasText {
            self.showAlert("Please fill out the textField", title: "Text Field can not empty", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text else {
            self.showAlert("Please fill out the textField", title: "Text Field can not empty", buttons: nil)
            return
        }
        
        if !Helpers.validateEmail(email) {
            self.showAlert("Email invalid format", title: "Field are required", buttons: nil)
            return
        }
        activityIndicatorView.showLoadingDialog(self)
        
        UserServices.shared.forgotPasswordWithEmail(withEmail: email) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Can not request new password", buttons: nil)
                return
            }
            self.showAlert("Mật khẩu mới đã được gửi tới email của bạn, vui lòng kiểm tra lại và đăng nhập", title: "Yêu cầu mật khẩu mới thành công", buttons: nil)
            
            if let appDelegate = self.appDelegate as? AppDelegate {
                appDelegate.showSignInView()
            }
        }
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        if let appDelegate = appDelegate as? AppDelegate {
            appDelegate.showSignInView()
        }
    }
    
}
