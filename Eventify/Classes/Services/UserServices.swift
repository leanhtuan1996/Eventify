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
                
                UserManager.shared.currentUser = user
                
                return completionHandler(user, nil)
                
            })
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
        guard user.email != nil, user.password != nil  else {
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
    
    func signInWithGoogle(with token: String, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> Void) {
        socket.emit("sign-in-with-google-plus", with: [token])
        
        socket.once("sign-in-with-google-plus") { (data, ack) in
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
    
    func signInWithFacebook(token: FBSDKAccessToken, completionHandler: @escaping (_ error: String?) -> Void) {
        
    }
    
    func signInWithZalo(vc: UIViewController, completionHandler: @escaping (_ error: String?) -> Void) {
        
        
    }
    
    func forgotPasswordWithEmail(withEmail email: String, completionHandler: @escaping(_ error: String?) -> Void ) {
    }
    
    func updateEmail(withPassword password: String, withEmail email: String, completionHandler: @escaping (_ error: String? ) -> Void ) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Current user not found")
        }
        
        socket.emit("update-email", with: [password, email, token])
        
        socket.once("update-email") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                UserManager.shared.currentUser?.email = email
                
                return completionHandler(nil)
            })
        }
    }
    
    func updatePhoneNumber(withPhone phone: String, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Current user not found")
        }
        
        socket.emit("update-phone-number", with: [phone, token])
        
        socket.once("update-phone-number") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                UserManager.shared.currentUser?.phoneNumber = phone
                
                return completionHandler(nil)
            })
        }
    }
    
    func updatePassword(withCurrentPw currentPw: String, andNewPw newPw: String, completionHandler: @escaping (_ error: String? )-> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Current user not found")
        }
        
        socket.emit("update-password", with: [currentPw, newPw, token])
        
        socket.once("update-password") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                return completionHandler(nil)
            })
        }
    }
    
    func updatePhotoURL(withImage image: Data, completionHandler: @escaping (_ error: String?) -> Void) {
        //upload-image-user
        guard let user = UserManager.shared.currentUser, let token = user.token else {
            return completionHandler("Current user not found")
        }
        
        let imgPath = "\(user.id)\(Helpers.getTimeStampWithInt()).jpg"
        socket.emit("upload-image-user", with: [image, imgPath, token])
        
        socket.once("upload-image-user") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let path = json[0]["path"] as? String else {
                    return completionHandler("Path not found")
                }
                
                UserManager.shared.currentUser?.photoDisplayPath = path
                
                return completionHandler(nil)
            })
        }
    }
    
    func updateFullname(withFullname fullname: String, completionHandler: @escaping (_ error: String?) -> Void) {
      
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Current user not found")
        }
        
        socket.emit("update-full-name", with: [fullname, token])
        
        socket.once("update-full-name") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                UserManager.shared.currentUser?.fullName = fullname
                
                return completionHandler(nil)
            })
        }
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
}
