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

class UserServicesTest: NSObject {
    
    static let shared = UserServicesTest()
    
    let socket = SocketIOServices.shared.socket
    
    func getInformations(with token: String, completionHandler: @escaping ((_ user: UserObjectTest?, _ error: String? ) -> Void )) {
        
        socket.emit("get-informations", with: [token])
        
        socket.once("get-informations") { (data, ack) in
            
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
        
        socket.emit("get-informations", with: [token])
        
        socket.once("get-informations") { (data, ack) in
            print(data)
        }
    }
    
    
    //sign up with email & password
    func signUp(with user: UserObjectTest, completionHandler: @escaping(_ error: String?) -> Void) {
        
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
    
    func getLikedEvents(completionHandler: @escaping (_ idEvents: [String]?, _ error: String? ) -> Void ) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token of User is required")
        }
        
        socket.emit("get-liked-events", with: [token])
        
        socket.off("get-liked-events")
        
        socket.on("get-liked-events") { (data, ack) in
            //check data is nil or empty
            //print(data)
            if data.isEmpty || data.count == 0 {
                return completionHandler(nil, "Data not found")
            }
            
            guard let array = data[0] as? [String] else {
                return completionHandler([], nil)
            }
            
            return completionHandler(array, nil)
            
        }
    }
    
    //    func getLikedEvents(completionHandler: @escaping (_ Events: [EventObjectTest]?, _ error: String?) -> Void ) {
    //
    //    }
    
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
