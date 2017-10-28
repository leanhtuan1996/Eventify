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
let refLiked = Firestore.firestore().collection("Liked")
let refStorage = Storage.storage()
let refImagePhotoUser = refStorage.reference().child("Images").child("UserAvatar")

class UserServices: NSObject {
    static let shared = UserServices()
    
    //ref User child
    
    var currentUser: UserObject?
    
    //addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, location: AddressObject,  completion: ((_ error: String?) -> Void)? = nil)
    //listen info user
    func getMyInformations(withId id: String?, completionHandler: ((_ user: UserObject?, _ error: String? ) -> Void )? = nil ) {
        print("listening")
        guard let id = id else {
            completionHandler?(nil, "1")
            return
        }
        
        refUser.document(id).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completionHandler?(nil, error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                print("2")
                completionHandler?(nil, "2")
                return
            }
            
            if let user = UserObject(json: snapshot.data()) {
                
                refUser.document(id).collection("liked").addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        completionHandler?(nil, error.localizedDescription)
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("error")
                        completionHandler?(nil, "error")
                        return
                    }
                    
                    var likedEvent: [EventObject] = []
                    
                    documents.forEach({ (document) in
                        
                        guard let event = EventObject(json: document.data()) else {
                            return
                        }
                        print(event.name)
                        likedEvent.append(event)
                    })
                    
                    user.liked = likedEvent
                    
                    self.currentUser = user
                    
                    completionHandler?(user, nil)
                })
                
            } else {
                completionHandler?(nil, "2")
            }
            
        }
    }
    
    func getUserInformations(withId id: String, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> Void ) {
        refUser.document(id).getDocument { (snapshot, error) in
            
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let json = snapshot?.data(), let user = UserObject(json: json) else {
                return completionHandler(nil, "Parse data fail")
            }
            
            return completionHandler(user, nil)
        }
    }
    
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
    
    func isLoggedIn(completionHandler: @escaping(_ error: String?) -> Void) {
        
        if let user = Auth.auth().currentUser {
            
            let userObject = UserObject()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.fullName = user.displayName
            userObject.phone = user.phoneNumber
            
            if let photoUrl = user.photoURL {
                userObject.photoURL = String(describing: photoUrl)
            }
            
            self.currentUser = userObject
            
            guard let userJson = userObject.toJSON() else {
                return completionHandler("Convert user to json has been failed")
            }
            
            refUser.document(user.uid).setData(userJson, options: SetOptions.merge())
            
            return completionHandler(nil)
        }
        return completionHandler("Current user is not found")
        
        //Auth.auth().addStateDidChangeListener { (auth, user) in
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
        //            if let user = user {
        //
        //                let userObject = UserObject()
        //                userObject.id = user.uid
        //                userObject.email = user.email
        //                userObject.fullName = user.displayName
        //                userObject.phone = user.phoneNumber
        //
        //                if let photoUrl = user.photoURL {
        //                    userObject.photoURL = String(describing: photoUrl)
        //                }
        //
        //                self.currentUser = userObject
        //
        //                guard let userJson = userObject.toJSON() else {
        //                    return completionHandler("Convert user to json has been failed")
        //                }
        //
        //                refUser.document(user.uid).setData(userJson, options: SetOptions.merge())
        //                self.getInformations(withId: user.uid)
        //                completionHandler(nil)
        //
        //            } else {
        //                return completionHandler("User not found")
        //            }
        //        }
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
    
    func likeEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void ) {
        guard let idUser = self.currentUser?.id, let eventJson = event.toJSON(), let eventId = event.id else {
            print("Current user not found")
            return completionHandler("Current user not found")
        }
        //print("LIKED")
//        refUser.document(idUser).collection("liked").addDocument(data: eventJson) { (error) in
//            
//        }
        
        refUser.document(idUser).collection("liked").document(eventId).setData(eventJson, options: SetOptions.merge()) { (error) in
            return completionHandler(error?.localizedDescription)
        }
        
        
        //        refUser.document(refCurrentUser).setData([eventId : eventJson], options: SetOptions.merge()) { (error) in
        //            return completionHandler(error?.localizedDescription)
        //        }
        
        //refLiked.document(idUser).setData(<#T##documentData: [String : Any]##[String : Any]#>, options: <#T##SetOptions#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    func UnlikeEvent(withId id: String, completionHandler: @escaping (_ error: String?) -> Void ) {
        
        guard let idUser = self.currentUser?.id else {
            print("Current user not found")
            return completionHandler("Current user not found")
        }
        
        refUser.document(idUser).collection("liked").document(id).delete { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
    func deleteUsers() {
        refUser.getDocuments { (snapshot, error) in
            let batch = refUser.firestore.batch()
            snapshot?.documents.forEach({ batch.deleteDocument($0.reference) })
            
            batch.commit(completion: { (error) in
                
            })
        }
        
        
    }
    
    func deleteUsers(batchSize: Int = 100, completion: ((Error?) -> ())? = nil) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        refUser.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            guard let docset = docset else {
                completion?(error)
                return
            }
            // There's nothing to delete.
            guard docset.count > 0 else {
                completion?(nil)
                return
            }
            
            let batch = refUser.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    // Stop the deletion process and handle the error. Some elements
                    // may have been deleted.
                    completion?(batchError)
                } else {
                    self.deleteUsers(batchSize: batchSize, completion: completion)
                }
            }
        }
    }
}
