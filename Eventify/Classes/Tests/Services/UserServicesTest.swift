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
    
    func getInformations(with token: String, completionHandler: @escaping ((_ user: UserObjectTest?, _ error: String? ) -> Void )) {
        
        socketUser.emit("get-informations", with: [token])
        
        socketUser.once("get-informations") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
               
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                guard let user = UserObjectTest(json: json[0]) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(user, nil)
                
            })
        }
        
    }
    
    func getInformations(completionHandler: @escaping ((_ user: UserObjectTest?, _ error: String? ) -> Void )) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketUser.emit("get-informations", with: [token])
        
        socketUser.once("get-informations") { (data, ack) in
            print(data)
        }
    }
    
    
    //sign up with email & password
    func signUp(with user: UserObjectTest, completionHandler: @escaping(_ error: String?) -> Void) {
        guard let email = user.email, let password = user.password else {
            return completionHandler("Email or password are required!")
        }
        
        if socket.isNotConnected() { socket.establishConnection() }
        
        if socket.isDisconnected() { socket.reConnect() }
        
        let userObject = UserObjectTest()
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
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let user = UserObjectTest(json: json[0]) else {
                    return completionHandler("Convert json to object has been failed")
                }
                
                UserManager.shared.setUser(with: user)
                
                return completionHandler(nil)
                
            })
        }
    }
    
    func signIn(with user: UserObjectTest, completionHandler: @escaping(_ error: String?) -> Void) {
        guard let email = user.email, let password = user.password else {
            return completionHandler("Email or password are required!")
        }
        
        if socket.isNotConnected() { socket.establishConnection() }
        
        if socket.isDisconnected() { socket.reConnect() }
        
        let userObject = UserObjectTest()
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
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let user = UserObjectTest(json: json[0]) else {
                    return completionHandler("Convert json to object has been failed")
                }
                
                UserManager.shared.setUser(with: user)
                
                return completionHandler(nil)
                
            })
        }
    }
    
    func isLoggedIn(completionHandler: @escaping(_ error: String?) -> Void) {
        
        
    }
    
    func signOut() {
        UserManager.shared.editToken(nil)
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
