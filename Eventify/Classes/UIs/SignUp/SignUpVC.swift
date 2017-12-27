//
//  SignUpVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    //save informations of user from access token
    var user: UserObject?
    
    let activityIndicatorView = UIActivityIndicatorView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        txtEmail.tag = 1
        txtEmail.delegate = self
        
        //Password textField
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.backgroundColor = UIColor.clear
        txtPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.textColor = UIColor.white
        txtPassword.tag = 4
        txtPassword.delegate = self
        
        //Password textField
        txtConfirmPassword.layer.borderColor = UIColor.white.cgColor
        txtConfirmPassword.layer.borderWidth = 1
        txtConfirmPassword.layer.cornerRadius = 5
        txtConfirmPassword.backgroundColor = UIColor.clear
        txtConfirmPassword.attributedPlaceholder =
            NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtConfirmPassword.textColor = UIColor.white
        txtConfirmPassword.tag = 5
        txtConfirmPassword.delegate = self
        
        //txtFullname textField
        txtFullname.layer.borderColor = UIColor.white.cgColor
        txtFullname.layer.borderWidth = 1
        txtFullname.layer.cornerRadius = 5
        txtFullname.backgroundColor = UIColor.clear
        txtFullname.attributedPlaceholder =
            NSAttributedString(string: "Họ và Tên", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtFullname.textColor = UIColor.white
        txtFullname.tag = 2
        txtFullname.delegate = self
        
        //Phone number textField
        txtPhoneNumber.layer.borderColor = UIColor.white.cgColor
        txtPhoneNumber.layer.borderWidth = 1
        txtPhoneNumber.layer.cornerRadius = 5
        txtPhoneNumber.backgroundColor = UIColor.clear
        txtPhoneNumber.attributedPlaceholder =
            NSAttributedString(string: "Số điện thoại", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPhoneNumber.textColor = UIColor.white
        txtPhoneNumber.tag = 3
        txtPhoneNumber.delegate = self
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Sign Up button
        btnSignUp.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = self.user else {
            return
        }
        
        self.txtEmail.text = user.email
        self.txtPhoneNumber.text = user.phoneNumber
        self.txtFullname.text = user.fullName
    }
    
    // MARK: - FUNCTIONS
    
    func signUp() {
        if !(txtEmail.hasText && txtPassword.hasText && txtFullname.hasText && txtPhoneNumber.hasText) {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text, let retypePassword = txtConfirmPassword.text, let fullName = txtFullname.text, let phoneNumber = txtPhoneNumber.text else {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        if password != retypePassword {
            self.showAlert("Fields are required", title: "Retype password not match", buttons: nil)
            return
        }
        
        activityIndicatorView.showLoadingDialog(self)
        
        //for 
        let userObject = UserObject()
        userObject.password = password
        userObject.email = email
        userObject.fullName = fullName
        userObject.phoneNumber = phoneNumber
        
        UserServices.shared.signUp(with: userObject) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Sign In Error", buttons: nil)
                return
            }
            self.appDelegate.showMainView()
        }
    }
    
    // MARK: - ACTION
    
    @IBAction func btnSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        print("signIn")
        appDelegate.showSignInView()
    }
    
    // MARK: - DELEGATE UITEXTFIELDS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signUp()
            return true
        }
        return false
    }
    
}
