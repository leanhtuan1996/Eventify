//
//  SignUpVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        //Email textfield
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 5
        txtEmail.backgroundColor = UIColor.clear
        txtEmail.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        txtEmail.textColor = UIColor.white
        
        //Password textField
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.backgroundColor = UIColor.clear
        txtPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        txtPassword.textColor = UIColor.white
        
        //Password textField
        txtConfirmPassword.layer.borderColor = UIColor.white.cgColor
        txtConfirmPassword.layer.borderWidth = 1
        txtConfirmPassword.layer.cornerRadius = 5
        txtConfirmPassword.backgroundColor = UIColor.clear
        txtConfirmPassword.attributedPlaceholder =
            NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        txtConfirmPassword.textColor = UIColor.white
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Sign Up button
        btnSignUp.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ACTION

    @IBAction func btnSignUp(_ sender: Any) {
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        appDelegate.showSignInView()
    }
    

}
