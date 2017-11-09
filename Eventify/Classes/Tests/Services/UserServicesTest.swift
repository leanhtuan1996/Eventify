//
//  UserServicesTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import Gloss
import FBSDKLoginKit

let refUserTest = Firestore.firestore().collection("Users")
let refImagePhotoUserTest = Storage.storage().reference().child("Images").child("PhotoDisplay")

class UserServicesTest: NSObject {
    static let shared = UserServicesTest()
    
    //ref User child
    
    var currentUser: UserObjectTest?
    
    func getMyInformations(completionHandler: ((_ user: UserObjectTest?, _ error: String? ) -> Void )? = nil ) {
        print("listening")
        guard let currentUser = self.currentUser else {
            completionHandler?(nil, "1")
            return
        }
        
        refUser.document(currentUser.id).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completionHandler?(nil, error.localizedDescription)
                return
            }
            
            guard let snapshotDoc = snapshot, snapshotDoc.exists else {
                print("2")
                completionHandler?(nil, "2")
                return
            }
            
            
            
            if let user = UserObjectTest(json: snapshotDoc.data()) {
                
                refLikedEvents.document(user.id).addSnapshotListener({ (snapshot, error) in
                    if let error = error {
                        completionHandler?(nil, error.localizedDescription)
                        return
                    }
                    
                    guard let dataSnapshot = snapshot, dataSnapshot.exists else {
                        completionHandler?(nil, "Snapshot not found")
                        return
                    }
                    
                    var likedEvent: [EventObjectTest] = []
                    
                    dataSnapshot.data().forEach({ (id, event) in
                        if let eventJson = event as? JSON {
                            if let eventObject = EventObjectTest(json: eventJson) {
                                likedEvent.append(eventObject)
                            }
                        }
                    })
                    
                    //user.liked = likedEvent
                    
                    self.currentUser = user
                    
                    completionHandler?(user, nil)
                    
                })
                
                //                refUser.document(id).collection("liked").addSnapshotListener({ (snapshot, error) in
                //
                //                    if let error = error {
                //                        completionHandler?(nil, error.localizedDescription)
                //                        return
                //                    }
                //
                //                    guard let documents = snapshot?.documents else {
                //                        print("error")
                //                        completionHandler?(nil, "error")
                //                        return
                //                    }
                //
                //                    var likedEvent: [EventObject] = []
                //
                //                    documents.forEach({ (document) in
                //
                //                        guard let event = EventObject(json: document.data()) else {
                //                            return
                //                        }
                //                        //print(event.name)
                //                        likedEvent.append(event)
                //                    })
                //                    
                //                    user.liked = likedEvent
                //                    
                //                    self.currentUser = user
                //                    
                //                    completionHandler?(user, nil)
                //                })
                
            } else {
                completionHandler?(nil, "2")
            }
            
        }
    }
    
    func getUserInformations(withId id: String, completionHandler: @escaping (_ user: UserObjectTest?, _ error: String?) -> Void ) {
    }
    
    //sign up with email & password
    func signUp(with user: UserObjectTest, completionHandler: @escaping(_ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler("Password not empty")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let user = user {
                
                let userObject = UserObjectTest()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.fullName = user.displayName
                
                if let photoUrl = user.photoURL {
                    userObject.photoDisplayPath = String(describing: photoUrl)
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
    
    //sign in with id & password
    func signIn(with user: UserObjectTest, completionHandler: @escaping(_ error: String?) -> Void) {
        
        guard let password = user.password, let email = user.email else {
            return completionHandler("Password is required")
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            if let user = user {
                let userObject = UserObjectTest()
                userObject.id = user.uid
                userObject.email = user.email
                userObject.phoneNumber = user.phoneNumber
                userObject.fullName = user.displayName
                
                if let photoUrl = user.photoURL {
                    userObject.photoDisplayPath = String(describing: photoUrl)
                }
                //set current user
                self.currentUser = userObject
                
                return completionHandler(nil)
            }
        }
    }
    
    //check isLoggedIn
    func isLoggedIn(completionHandler: @escaping(_ error: String?) -> Void) {
        
        if let user = Auth.auth().currentUser {
            
            let userObject = UserObjectTest()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.fullName = user.displayName
            userObject.phoneNumber = user.phoneNumber
            if let photoUrl = user.photoURL {
                userObject.photoDisplayPath = String(describing: photoUrl)
            }
            
            self.currentUser = userObject
            print(userObject.id)
            guard let userJson = userObject.toJSON() else {
                return completionHandler("Convert user to json has been failed")
            }
            
            refUser.document(user.uid).setData(userJson, options: SetOptions.merge())
            
            return completionHandler(nil)
        }
        return completionHandler("Current user is not found")
        
        //Auth.auth().addStateDidChangeListener { (auth, user) in
        //            if let user = user {
        //                let UserObjectTest = UserObjectTest()
        //                UserObjectTest.id = user.uid
        //                UserObjectTest.email = user.email
        //                UserObjectTest.fullName = user.displayName
        //                UserObjectTest.phone = user.phoneNumber
        //                UserObjectTest.photoURL = String(describing: user.photoURL)
        //                self.currentUser = UserObjectTest
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
        ////                                //self.currentUser = UserObjectTest(json: resPro.data as! JSON)
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
        //                let UserObjectTest = UserObjectTest()
        //                UserObjectTest.id = user.uid
        //                UserObjectTest.email = user.email
        //                UserObjectTest.fullName = user.displayName
        //                UserObjectTest.phone = user.phoneNumber
        //
        //                if let photoUrl = user.photoURL {
        //                    UserObjectTest.photoURL = String(describing: photoUrl)
        //                }
        //
        //                self.currentUser = UserObjectTest
        //
        //                guard let userJson = UserObjectTest.toJSON() else {
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
    
    //Sign out googlePlus & firebase Auth
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
    
    //Sign In with Google Plus
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
            
            
            let userObject = UserObjectTest()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.phoneNumber = user.phoneNumber
            
            if let photoUrl = user.photoURL {
                userObject.photoDisplayPath = String(describing: photoUrl)
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
    
    //Sign in with Facebook
    func signInWithFacebook(token: FBSDKAccessToken, completionHandler: @escaping (_ error: String?) -> Void) {
        //print(token.tokenString)
        let auth = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        Auth.auth().signIn(with: auth) { (user, error) in
            if let error = error {
                return completionHandler(error.localizedDescription)
            }
            
            guard let user = user else {
                return completionHandler("SIGN IN WITH FACEBOOK HAD BEEN ERROR")
            }
            
            let userObject = UserObjectTest()
            userObject.id = user.uid
            userObject.email = user.email
            userObject.phoneNumber = user.phoneNumber
            userObject.fullName = user.displayName
            
            if let photoUrl = user.photoURL {
                userObject.photoDisplayPath = String(describing: photoUrl)
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
        
//        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: vc) { (response) in
//            guard let response = response else {
//                return completionHandler("LOGIN WITH ZALO HAS BEEN FAILED")
//            }
//            
//            if response.isSucess {
//                guard let _ = response.oauthCode else {
//                    return completionHandler("TOKEN NOT FOUND")
//                }
//                
//                let UserObjectTest = UserObjectTest()
//                UserObjectTest.id = response.userId
//                UserObjectTest.phone = response.phoneNumber
//                UserObjectTest.fullName = response.displayName
//                UserObjectTest.token = response.oauthCode
//                UserObjectTest.dob = response.dob
//                
//                //set current user
//                self.currentUser = UserObjectTest
//                
//                guard let userJson = UserObjectTest.toJSON() else {
//                    return completionHandler("Convert user to json has been failed")
//                }
//                
//                refUser.document(UserObjectTest.id).setData(userJson, options: SetOptions.merge(), completion: { (error) in
//                    if let error = error {
//                        return completionHandler("Insert into database has been failed with error: \(error.localizedDescription)")
//                    }
//                    
//                    return completionHandler(nil)
//                })
//            }  else {
//                if response.errorCode != kZaloSDKErrorCodeUserCancel.rawValue.hashValue {
//                    return completionHandler(response.errorMessage)
//                }
//            }
//            
//        }
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
                    //self.currentUser?.password = pw
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
                self.currentUser?.photoDisplayPath = metaData.path
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
    
    func likeEvent(withEvent event: EventObjectTest, completionHandler: @escaping (_ error: String?) -> Void ) {
        
        guard let currentUser = self.currentUser else {
            print("Current user not found")
            return completionHandler("Current user not found")
        }
        
        guard let eventJson = event.toJSON() else {
            print("Current user not found")
            return completionHandler("Current user not found")
        }
        //print("LIKED")
        //        refUser.document(idUser).collection("liked").addDocument(data: eventJson) { (error) in
        //
        //        }
        
        //        refUser.document(idUser).collection("liked").document(eventId).setData(eventJson, options: SetOptions.merge()) { (error) in
        //            return completionHandler(error?.localizedDescription)
        //        }
        
        //for testing
        refLikedEvents.document(currentUser.id).setData([event.id : eventJson], options: SetOptions.merge()) { (error) in
            return completionHandler(error?.localizedDescription)
        }
        
        
        //        refUser.document(refCurrentUser).setData([eventId : eventJson], options: SetOptions.merge()) { (error) in
        //            return completionHandler(error?.localizedDescription)
        //        }
        
        //refLiked.document(idUser).setData(<#T##documentData: [String : Any]##[String : Any]#>, options: <#T##SetOptions#>, completion: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
    
    func UnlikeEvent(withId id: String, completionHandler: @escaping (_ error: String?) -> Void ) {
        
        guard let currentUser = self.currentUser else {
            print("Current user not found")
            return completionHandler("Current user not found")
        }
        
        //        refUser.document(idUser).collection("liked").document(id).delete { (error) in
        //            return completionHandler(error?.localizedDescription)
        //        }
        
        //for testing
        refLikedEvents.document(currentUser.id).updateData([id : FieldValue.delete()]) { (error) in
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
