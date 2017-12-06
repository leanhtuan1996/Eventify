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
import FBSDKLoginKit
import Gloss

class UserServices: NSObject {
    
    static let shared = UserServices()
    
    let socket = SocketIOServices.shared.socket
    
    func getInformations(with token: String, completionHandler: @escaping ((_ user: UserObject?, _ error: String? ) -> Void )) {
        
        socket.emit("get-informations", with: [token])
        
        socket.once("get-informations") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                guard let user = UserObject(json: json[0]) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(user, nil)
                
            })
        }
        
    }
    
    func getInformations(completionHandler: @escaping ((_ user: UserObject?, _ error: String? ) -> Void )) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socket.emit("get-informations", with: [token])
        
        socket.once("get-informations") { (data, ack) in
            //print(data)
        }
    }
    
    
    //sign up with email & password
    func signUp(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        
        guard let userJson = user.toJSON() else {
            return completionHandler("Parse user to json has been failed")
        }
        
        
        //request to server
        socket.emit("sign-up", with: [userJson])
        
        //listen
        socket.once("sign-up") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let user = UserObject(json: json[0]) else {
                    return completionHandler("Convert json to object has been failed")
                }
                
                UserManager.shared.setUser(with: user)
                
                return completionHandler(nil)
                
            })
        }
    }
    
    func signIn(with user: UserObject, completionHandler: @escaping(_ error: String?) -> Void) {
        guard let email = user.email, let password = user.password else {
            return completionHandler("Email or password are required!")
        }
        
        guard let userJson = user.toJSON() else {
            return completionHandler("Parse user to json has been failed")
        }
        
        //request to server
        socket.emit("sign-in", with: [userJson])
        
        //add new listener
        socket.once("sign-in") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let user = UserObject(json: json[0]) else {
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
    
    func getLikedEvents(_ completionHandler:  ((_ error: String? ) -> Void)? = nil ) {
        guard let token = UserManager.shared.currentUser?.token else {
             completionHandler?("Token of User is required")
            return
        }
        
        socket.emit("get-liked-events", with: [token])
        
        socket.off("get-liked-events")
        
        socket.on("get-liked-events") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    completionHandler?(error)
                    return
                }
                
                guard let json = json, json.count > 0 else {
                    completionHandler?("Data is empty")
                    return
                }
                
                //print(json)
                
                if json[0].isEmpty {
                    UserManager.shared.currentUser?.liked = []
                    completionHandler?(nil)
                    return
                }
                
                //print(json)
                
                //try parse from json to object
                guard let events = [EventObject].from(jsonArray: json) else {
                    completionHandler?("Path not found")
                    return
                }
                
                UserManager.shared.currentUser?.liked = events
                
                completionHandler?(nil)
            })
            
        }
    }
    
    func likeEvent(with id: String) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            return
        }
        
        socket.emit("like-event", with: [id, token])
        
    }
    
    func UnlikeEvent(with id: String) {
        guard let token = UserManager.shared.currentUser?.token else {
            return
        }
        socket.emit("unlike-event", with: [id, token])
    }
    
    func deleteUsers() {
        
        
        
    }
    
    func deleteUsers(batchSize: Int = 100, completion: ((Error?) -> ())? = nil) {
        
    }
    
}
