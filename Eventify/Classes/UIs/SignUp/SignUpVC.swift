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
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
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
        txtPassword.tag = 2
        txtPassword.delegate = self
        
        //Password textField
        txtConfirmPassword.layer.borderColor = UIColor.white.cgColor
        txtConfirmPassword.layer.borderWidth = 1
        txtConfirmPassword.layer.cornerRadius = 5
        txtConfirmPassword.backgroundColor = UIColor.clear
        txtConfirmPassword.attributedPlaceholder =
            NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtConfirmPassword.textColor = UIColor.white
        txtConfirmPassword.tag = 3
        txtConfirmPassword.delegate = self
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Sign Up button
        btnSignUp.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FUNCTIONS
    
    func signUp() {
        if !(txtEmail.hasText && txtPassword.hasText) {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text, let retypePassword = txtConfirmPassword.text else {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        if password != retypePassword {
            self.showAlert("Fields are required", title: "Retype password not match", buttons: nil)
            return
        }
        
        activityIndicatorView.showLoadingDialog(self)
        let userObject = UserObject()
        userObject.password = password
        userObject.email = email
        
        UserServicesTest.shared.signUp(with: userObject) { (error) in
            
        }
        
        UserServices.shared.signUp(with: userObject) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Sign In Error", buttons: nil)
                return
            }
            //self.appDelegate.showMainView()
        }
    }
    
    // MARK: - ACTION
    
    @IBAction func btnSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
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
