//
//  UserServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SocketIO
import GoogleSignIn
import FirebaseCore
import FBSDKLoginKit
import Gloss

class UserServicesTest: NSObject {
    
    static let shared: UserServicesTest = {
        print("INIT USERSERVICETEST")
        SocketIOServices.shared.join(withNameSpace: "/user")
        return UserServicesTest()
    }()
    
    let socket = SocketIOServices.shared
    let socketUser = SocketIOServices.shared.socket
    
    var count = 0
    
    var currentUser: UserObjectTest?
    
    func getMyInformations(withId id: String?, completionHandler: ((_ user: UserObject?, _ error: String? ) -> Void )? = nil ) {
       
    }
    
    func getUserInformations(withId id: String, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> Void ) {
        
    }
    
    //sign up with email & password
    func signUp(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        guard let email = user.email, let password = user.password else {
            return completionHandler("Email or password are required!")
        }
        
        if !socket.isConnected() { socket.establishConnection() }
        
        let userObject = UserObject()
        userObject.id = ""
        userObject.email = email
        userObject.password = password
        
        guard let userJson = userObject.toJSON() else {
            return completionHandler("Parse user to json has been failed")
        }
        
        
        //request to server
        socketUser.emit("sign-up", with: [userJson])
        
        socketUser.off("sign-up")
        
        //listen
        socketUser.on("sign-up") { (data, ack) in
            print(data)
            self.count += 1
            print(self.count)
            
        }
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        guard let email = user.email, let password = user.password else {
            return completionHandler("Email or password are required!")
        }
        
        if socket.isNotConnected() { socket.establishConnection() }
        
        if socket.isDisconnected() { socket.reConnect() }
        
        let userObject = UserObject()
        userObject.email = email
        userObject.password = password
        
        guard let userJson = userObject.toJSON() else {
            return completionHandler("Parse user to json has been failed")
        }
        
        //request to server
        socketUser.emit("sign-in", with: [userJson])
        
        //delete previous listener
        socketUser.off("sign-in")
        
        //add new listener
        socketUser.on("sign-in") { (data, ack) in
            
            if data.isEmpty || data.count == 0 {
                return completionHandler("Data not found")
            }
            
            guard let json = data.first as? JSON else {
                print("Convert data to json has been failed")
                return completionHandler("Convert data to json has been failed")
            }
            
            if let errors = json["errors"] as? [String] {
                if errors.count != 0 {
                    return completionHandler(errors[0])
                } else {
                    return completionHandler("Error not found")
                }
            }
            
            guard let user = UserObjectTest(json: json) else {
                print("FAILED")
                return
            }
            
            self.currentUser = user
            
            return completionHandler(nil)
        }
    }
    
    func isLoggedIn(completionHandler: @escaping(_ error: String?) -> Void) {
        
        
    }
    
    func signOut() {
       
    }
    
    func signInWithGoogle(authentication: GIDAuthentication?, completionHandler: @escaping (_ error: String?) -> Void) {
        
        
    }
    
    func signInWithFacebook(token: FBSDKAccessToken, completionHandler: @escaping (_ error: String?) -> Void) {
       
    }
    
    func signInWithZalo(vc: UIViewController, completionHandler: @escaping (_ error: String?) -> Void) {
        
       
    }
    
    func forgotPasswordWithEmail(withEmail email: String, completionHandler: @escaping(_ error: String?) -> Void ) {
           }
    
    func updateEmail(withEmail email: String, completionHandler: @escaping (_ error: String? ) -> Void ) {
        
    }
    
    func updatePhoneNumber(withPhone phone: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        
    }
    
    func updatePassword(withPassword pw: String, completionHandler: @escaping (_ error: String? )-> Void) {
        
    }
    
    func updatePhotoURL(withImage image: Data, completionHandler: @escaping (_ error: String?) -> Void) {
            }
    
    func updateFullname(withFullname fullname: String, completionHandler: @escaping (_ error: String?) -> Void) {
       
    }
    
    func likeEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void ) {
            }
    
    func UnlikeEvent(withId id: String, completionHandler: @escaping (_ error: String?) -> Void ) {
        
        
    }
    
    func deleteUsers() {
       
        
        
    }
    
    func deleteUsers(batchSize: Int = 100, completion: ((Error?) -> ())? = nil) {
       
    }

}
