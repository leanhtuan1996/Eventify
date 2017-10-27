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
import FBSDKLoginKit
import ZaloSDK

let refUser = Firestore.firestore().collection("Users")
let refStorage = Storage.storage()
let refImagePhotoUser = refStorage.reference().child("Images").child("UserAvatar")

class UserServices: NSObject {
    static let shared = UserServices()
    
    //ref User child
    
    var currentUser: UserObject?
    
    //sign up with email & password
    func signUp(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler("Password not empty")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let user = user {
                
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.phone = user.phoneNumber
                userObject.fullName = user.displayName
                
                if let photoUrl = user.photoURL {
                    userObject.photoURL = String(describing: photoUrl)
                }
               
                //set current user
                self.currentUser = userObject
                
                guard let userJson = userObject.toJSON() else {
                    return completionHandler("Convert user to json has been failed")
                }
                
                refUser.document(user.uid).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                    if let error = error {
                        return completionHandler("Insert into database has been failed with error: \(error.localizedDescription)")
                    }
                    
                    return completionHandler(nil)
                })
            }
        }
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler("Password is required")
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let user = user {
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.phone = user.phoneNumber
                userObject.fullName = user.displayName
                
                if let photoUrl = user.photoURL {
                    userObject.photoURL = String(describing: photoUrl)
                }
                
                //set current user
                self.currentUser = userObject
                
                return completionHandler(nil)
            }
        }
    }
    
    //listener
    func isLoggedIn(completionHandler: @escaping(_ error: String?) -> Void) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            //            if let user = user {
            //                let userObject = UserObject()
            //                userObject.id = user.uid
            //                userObject.email = user.email
            //                userObject.fullName = user.displayName
            //                userObject.phone = user.phoneNumber
            //                userObject.photoURL = String(describing: user.photoURL)
            //                self.currentUser = userObject
            //                return completionHandler(nil)
            //            } else {
            //
            //                //check zalo
            //                ZaloSDK.sharedInstance().isAuthenticatedZalo { (response) in
            //                    if let res = response {
            //
            //                        if res.errorCode == kZaloSDKErrorCodeNotLoggedIn.rawValue.hashValue {
            //                            return completionHandler("User not found")
            //                        }
            //
            //
            //
            ////                        ZaloSDK.sharedInstance().getZaloUserProfile(callback: { (responseProfile) in
            ////                            if let resPro = responseProfile {
            ////                                //self.currentUser = UserObject(json: resPro.data as! JSON)
            ////                            }
            ////                        })
            //
            //                        return completionHandler("asdsad")
            //
            //                    } else {
            //                        return completionHandler("User not found")
            //                    }
            //                }
            //            }
            if let user = user {
                let userObject = UserObject()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.fullName = user.displayName
                userObject.phone = user.phoneNumber
                
                if let photoUrl = user.photoURL {
                    userObject.photoURL = String(describing: photoUrl)
                }
                
                self.currentUser = userObject
                return completionHandler(nil)
            }
            return completionHandler("User not found")
        }
    }
    
    func signOut() {
        do
        {
            //for google
            if let _ = GIDSignIn.sharedInstance().currentUser {
                GIDSignIn.sharedInstance().signOut()
            }
            
            //ZaloSDK.sharedInstance().unauthenticate()
            
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    func signInWithGoogle(authentication: GIDAuthentication?, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let authentication = authentication else {
            return completionHandler("Authentication not found")
        }
        
        let auth = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: auth) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            guard let user = user else {
                return completionHandler("SIGN IN WITH GOOGLE HAD BEEN ERROR")
            }
            
            
            let userObject = UserObject()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.phone = user.phoneNumber
            
            if let photoUrl = user.photoURL {
                userObject.photoURL = String(describing: photoUrl)
            }
            
            userObject.fullName = user.displayName
            //set current user
            self.currentUser = userObject
            
            guard let userJson = userObject.toJSON() else {
                return completionHandler("Convert user to json has been failed")
            }
            
            refUser.document(user.uid).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                if let error = error {
                    return completionHandler("Insert into database has been failed with error: \(error.localizedDescription)")
                }
                
                return completionHandler(nil)
            })
        }
    }
    
    func signInWithFacebook(token: FBSDKAccessToken, completionHandler: @escaping (_ error: String?) -> Void) {
        
        let auth = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        Auth.auth().signIn(with: auth) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            guard let user = user else {
                return completionHandler("SIGN IN WITH FACEBOOK HAD BEEN ERROR")
            }
            
            let userObject = UserObject()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.phone = user.phoneNumber
            userObject.fullName = user.displayName
            
            if let photoUrl = user.photoURL {
                userObject.photoURL = String(describing: photoUrl)
            }
            
            //set current user
            self.currentUser = userObject
            
            guard let userJson = userObject.toJSON() else {
                return completionHandler("Convert user to json has been failed")
            }
            
            refUser.document(user.uid).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                if let error = error {
                    return completionHandler("Insert into database has been failed with error: \(error.localizedDescription)")
                }
                
                return completionHandler(nil)
            })
            
        }
    }
    
    func signInWithZalo(vc: UIViewController, completionHandler: @escaping (_ error: String?) -> Void) {
        
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: vc) { (response) in
            guard let response = response else {
                return completionHandler("LOGIN WITH ZALO HAS BEEN FAILED")
            }
            
            if response.isSucess {
                guard let _ = response.oauthCode else {
                    return completionHandler("TOKEN NOT FOUND")
                }
                
                let userObject = UserObject()
                userObject.id = response.userId
                userObject.phone = response.phoneNumber
                userObject.fullName = response.displayName
                userObject.token = response.oauthCode
                userObject.dob = response.dob
                
                //set current user
                self.currentUser = userObject
                
                guard let userJson = userObject.toJSON() else {
                    return completionHandler("Convert user to json has been failed")
                }
                
                refUser.document(userObject.id).setData(userJson, options: SetOptions.merge(), completion: { (error) in
                    if let error = error {
                        return completionHandler("Insert into database has been failed with error: \(error.localizedDescription)")
                    }
                    
                    return completionHandler(nil)
                })
            }  else {
                if response.errorCode != kZaloSDKErrorCodeUserCancel.rawValue.hashValue {
                    return completionHandler(response.errorMessage)
                }
            }
            
        }
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
                
                refUser.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "email" : email], completion: { (error) in
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
                refUser.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "password" : pw], completion: { (error) in
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
            
            refUser.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "photoURL" : path], completion: { (error) in
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
        
        refUser.document(currentUser.id).updateData(["lastUpdated" : FieldValue.serverTimestamp(), "fullName" : fullname], completion: { (error) in
            if let error = error {
                return completionHandler("Insert to database has been failed with error: \(error)")
            }
            self.currentUser?.fullName = fullname
            return completionHandler(nil)
        })
    }
    
}
