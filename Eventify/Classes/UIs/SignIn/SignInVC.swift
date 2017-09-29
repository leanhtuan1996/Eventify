//
//  SignInVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let appDelegate = UIApplication.shared.delegate
    let activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GID
        GIDSignIn.sharedInstance().clientID = "323918211545-lkpctsjbvu71p05mqp1pa0sqpsun4d2l.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //Email textfield
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 5
        txtEmail.backgroundColor = UIColor.clear
        txtEmail.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.textColor = UIColor.white
        txtEmail.tag = 1
        txtEmail.becomeFirstResponder()
        
        //Password textField
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.backgroundColor = UIColor.clear
        txtPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.textColor = UIColor.white
        txtPassword.tag = 2
        txtPassword.returnKeyType = .go
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Sign Up button
        btnSignUp.layer.cornerRadius = 10
    }
    
    // MARK: - FUNCTIONS
    
    func signIn() {
        
        if !(txtEmail.hasText && txtPassword.hasText) {
            self.showAlert("Please fill all fields are required!", title: "Fields are required", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            return
        }
        
        let userObject = UserObject(id: "", email: email)
        userObject.password = password
        
        activityIndicatorView.showLoadingDialog(self)
        UserServices.shared.signIn(with: userObject) { (user, error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Sign In Error", buttons: nil)
                return
            }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                 appDelegate.showMainView()
            }
        }
    }
    
    // MARK : - ACTIONS
    
    @IBAction func btnFacebook(_ sender: Any) {
    }
    
    @IBAction func btnGooglePlus(_ sender: Any) {
        activityIndicatorView.showLoadingDialog(self)
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showForgotPwView()
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignUpView()
        }
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        signIn()
    }
    
    // MARK: - DELEGATE UITEXTFIELDS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signIn()
            return true
        }
        return false
    }
    
    // MARK: - SIGN IN FUNCTION WITH GID
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error) {
        
//        guard let signIn = signIn, let usr = user else {
//            print("asdsads")
//            return
//        }
        
        UserServices.shared.signInWithGoogle(authentication: user.authentication) { (user, error) in
            self.activityIndicatorView.stopAnimating()
            
            if let error = error {
                print(error)
                return
            }
            
            if let user = user {
                print(user.email)
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showMainView()
                }
            }
        }
    }
    
}
