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
    static let shared = UserServicesTest()
    
    let socket = SocketIOServices.shared
    let socketUser = SocketIOServices.shared.socket
    
    override init() {
        socket.join(withNameSpace: "/user")
        super.init()
    }
    
    var currentUser: UserObject?
    
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
        
        //listen
        socketUser.on("sign-up") { (data, ack) in
            print(data)
        }
        
        //request to server
        socketUser.emit("sign-up", with: [userJson])
        
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
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
        
        //listen
        socketUser.on("sign-in") { (data, ack) in
            print(data)
        }
        
        //request to server
        socketUser.emit("sign-in", with: [userJson])
        
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
