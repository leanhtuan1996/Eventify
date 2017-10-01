//
//  UserServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import Gloss

class UserServices: NSObject {
    static let shared = UserServices()
    
    //ref User child
    let refUser = Database.database().reference().child("Users")
    
    func signUp(with user: UserObject, completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler(nil, "Password not empty")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            if let user = user {
                let usr: [String: Any] = [
                    "id" : user.uid,
                    "email" : user.email ?? "",
                    "fullName" : user.displayName ?? "",
                    "phone" : user.phoneNumber ?? ""
                ]
                //print(user)
                
                self.refUser.child(user.uid).setValue(usr)
                
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
               
                return completionHandler(userObject, nil)
            }
        }
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler(nil, "Password is required")
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            if let user = user {
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                return completionHandler(userObject, nil)
            }
        }
    }
    
    //listener
    func isLoggedIn(completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                return completionHandler(userObject, nil)
            } else {
                return completionHandler(nil, "User not found")
            }
        }
    }
    
    func signOut() {
        do
        {
            if let _ = GIDSignIn.sharedInstance().currentUser {
                GIDSignIn.sharedInstance().signOut()
            }
            
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    func signInWithGoogle(authentication: GIDAuthentication?, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> Void) {
       
        guard let authentication = authentication else {
            return completionHandler(nil, "Authentication not found")
        }
        
        let auth = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: auth) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let user = user else {
                return completionHandler(nil, "SIGN IN WITH GOOGLE HAD BEEN ERROR")
            }
            
            let userObject = UserObject()
            userObject.id = user.uid
            userObject.email = user.email
            
            let usr: [String: Any] = [
                "id" : user.uid,
                "email" : user.email ?? "",
                "fullName" : user.displayName ?? "",
                "phone" : user.phoneNumber ?? ""
            ]
            //print(user)
            
            self.refUser.child(user.uid).setValue(usr)
            
            return completionHandler(userObject, nil)
        }
    }
    
    func signInWithFacebook() {
        
    }
    
    func forgotPasswordWithEmail(withEmail email: String, completionHandler: @escaping(_ error: String?) -> Void ) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            return completionHandler(nil)
        }
    }
    
    func getInfomations(completionHandler: @escaping(_ user: UserObject?, _ error: String?) -> Void) -> Void {
        let user = Auth.auth().currentUser
        if let uid = user?.uid {
            
            self.refUser.child(uid).observeSingleEvent(of: .value, with: { (data) in
                guard let value = data.value as? JSON else {
                    return completionHandler(nil, "Data is not avalid formation")
                }
                
                completionHandler(UserObject(json: value), nil)
            })
        }
        
    }
    
    func updateEmail() {
        
    }
    
    func updatePhoneNumber() {
        
    }
    
    func updatePassword() {
        
    }
    
    func updatePhotoURL() {
        
    }
    
    func updateFullname() {
        
    }
    
    
    
}
