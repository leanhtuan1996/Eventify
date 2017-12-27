//
//  UserManager.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    
    let userDefault = UserDefaults.standard
    
    var currentUser: UserObject?
    var token: String?
    
    
    //check token in NSUserDefaults
    func isLoggedIn() -> Bool {
        if let token = self.getToken() {
            self.editToken(token)
            return true
        }
        return false
    }
    
    //set token to NSUserDefaults
    func editToken(_ token: String?) {
        //if token is null => set
        //token is not nul => delete
        if let token = token {
            userDefault.set(token, forKey: "token")
        } else {
            if userDefault.object(forKey: "token") != nil {
                userDefault.removeObject(forKey: "token")
            }
        }
    }
    
    //Get token in NSUserDefaults
    func getToken() -> String? {
        if let token = userDefault.object(forKey: "token") as? String {
            return token
        }
        return nil
    }
    
    func verifyToken(_ completionHandler: @escaping(_ error: String?) -> Void) {
        if let token = self.getToken() {
            
            UserServices.shared.getInformations(with: token, completionHandler: { (user, error) in
                if let error = error {
                    //remove token 
                    self.editToken(nil)
                    return completionHandler(error)
                }
                
                if let user = user {
                    user.token = token
                    
                    self.setUser(with: user)
                    
                    OrderServices.shared.getOrders()
                    UserServices.shared.getLikedEvents()
                    
                    return completionHandler(nil)
                }
            })
           
        } else {
            return completionHandler("Verified token failed")
        }
    }
    
    func setUser(with user: UserObject?) {
        
        if let user = user {
            self.currentUser = user
            
            if let token = user.token {
                self.editToken(token)
            }
        } else {
            self.currentUser = nil
            self.editToken(nil)
        }
    }
}
