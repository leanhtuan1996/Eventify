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

class UserServices: NSObject {
    static let shared = UserServices()
    //ref User child
    let refUser = Database.database().reference().child("Users")
    
    func signUp(with user: UserObject, completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            if let user = user {
                let usr: [String: Any] = [
                    "id" : user.uid,
                    "email" : user.email ?? ""
                ]
                //print(user)
                
                self.refUser.childByAutoId().setValue(usr)
                return completionHandler(UserObject(id: user.uid, email: user.email ?? "", password: ""), nil)
            }
        }
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            if let user = user {
                let usr = UserObject(id: user.uid, email: user.email ?? "", password: "")
                return completionHandler(usr, nil)
            }
        }
    }
    
    //listener
    func isLoggedIn(completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                return completionHandler(UserObject(id: user.uid, email: user.email ?? "", password: ""), nil)
            } else {
                return completionHandler(nil, "User not found")
            }
        }
    }
    
    func signOut() {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
}
