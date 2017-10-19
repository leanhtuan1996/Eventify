//
//  UserServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Gloss
let refUserTest = Firestore.firestore().collection("Users")
let refImagePhotoUser = refStorageTest.reference().child("Images").child("UserAvatar")

class UserServicesTest: NSObject {
    static let shared = UserServicesTest()
    
    //ref User child
    
    var currentUser:UserObject?
    
    //sign up with email & password
    func signUp(with user: UserObject, completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler(nil, "Password not empty")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            if let user = user {
                
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.phone = user.phoneNumber
                userObject.photoURL = String(describing: user.photoURL)
                userObject.fullName = user.displayName
                
                //set current user
                self.currentUser = userObject
                
                guard let userJson = userObject.toJSON() else {
                    return completionHandler(nil, "Convert user to json has been failed")
                }
                
                refUserTest.document(user.uid).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                    if let error = error {
                        return completionHandler(nil, "Insert into database has been failed with error: \(error.localizedDescription)")
                    }
                    
                    return completionHandler(userObject, nil)
                })
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
                userObject.phone = user.phoneNumber
                userObject.photoURL = String(describing: user.photoURL)
                userObject.fullName = user.displayName
                
                //set current user
                self.currentUser = userObject
                
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
                userObject.fullName = user.displayName
                userObject.phone = user.phoneNumber
                userObject.photoURL = String(describing: user.photoURL)
                self.currentUser = userObject
                return completionHandler(userObject, nil)
            } else {
                return completionHandler(nil, "User not found")
            }
        }
    }
    
    func signOut() {
        do
        {
            //for google
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
            userObject.phone = user.phoneNumber
            userObject.photoURL = String(describing: user.photoURL)
            userObject.fullName = user.displayName
            
            //set current user
            self.currentUser = userObject
            
            guard let userJson = userObject.toJSON() else {
                return completionHandler(nil, "Convert user to json has been failed")
            }
            
            refUserTest.document(user.uid).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                if let error = error {
                    return completionHandler(nil, "Insert into database has been failed with error: \(error.localizedDescription)")
                }
                
                return completionHandler(userObject, nil)
            })
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
   
    
    func updateEmail(withEmail email: String, completionHandler: @escaping (_ error: String? ) -> Void ) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let currentUser = self.currentUser {

                refUserTest.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "email" : email], completion: { (error) in
                    if let error = error {
                        return completionHandler("Insert to database has been failed with error: \(error)")
                    }
                    self.currentUser?.email = email
                    
                    return completionHandler(nil)
                })
            } else {
                return completionHandler("Current user not found")
            }
        })
    }
    
    func updatePhoneNumber(withPhone phone: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        
    }
    
    func updatePassword(withPassword pw: String, completionHandler: @escaping (_ error: String? )-> Void) {
        Auth.auth().currentUser?.updatePassword(to: pw, completion: { (error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let currentUser = self.currentUser {
                refUserTest.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "password" : pw], completion: { (error) in
                    if let error = error {
                        return completionHandler("Insert to database has been failed with error: \(error)")
                    }
                    self.currentUser?.password = pw
                    return completionHandler(nil)
                })
            } else {
                return completionHandler("Current user not found")
            }
        })
    }
    
    func updatePhotoURL(withImage image: Data, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let currentUser = self.currentUser else {
            return completionHandler("User not found")
        }
        
        let keyPath = "\(currentUser.id)" + "\(Helpers.getTimeStamp()).jpg"
        
        let uploadTask = refImagePhotoUser.child(keyPath).putData(image, metadata: nil) { (metaData, error) in
            guard let metaData = metaData, let path = metaData.path else {
                return completionHandler( "MetaData not found")
            }
            
            refUserTest.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "photoURL" : path], completion: { (error) in
                if let error = error {
                    return completionHandler("Insert to database has been failed with error: \(error)")
                }
                self.currentUser?.photoURL = metaData.path
                return completionHandler(nil)
            })
        }
        
        uploadTask.resume()
    }
    
    func updateFullname(withFullname fullname: String, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let currentUser = self.currentUser else {
            return completionHandler("User not found")
        }
        
        refUserTest.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "fullName" : fullname], completion: { (error) in
            if let error = error {
                return completionHandler("Insert to database has been failed with error: \(error)")
            }
            self.currentUser?.fullName = fullname
            return completionHandler(nil)
        })
    }
    
}
