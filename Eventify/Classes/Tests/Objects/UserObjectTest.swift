//
//  UserObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class UserObjectTest: NSObject, Glossy {
    var id: String
    var fullName: String?
    var password: String?
    var email: String?
    var token: String?
    var photoDisplayPath: String?
    var phoneNumber: String?
    var orders: [OrderObjectTest]?
    var liked: [String]?
    
    override init() {
        self.id = ""
        super.init()        
    }
    
    required init?(json: JSON) {
        
        //Id has not nil
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        self.id = id
        
        //orders
        if let ordersJSON: [JSON] = "orders" <~~ json {
            self.orders = [OrderObjectTest].from(jsonArray: ordersJSON)
        }
        
        //liked
        if let likedString: [String] = "liked" <~~ json {
            //self.liked = [LikeEventObjectTest].from(jsonArray: likedJSON)
            self.liked = likedString
        }
        
        //token 
        self.token = "token" <~~ json
        
        //full name
        self.fullName = "fullName" <~~ json
        
        //email
        self.email = "email" <~~ json
        
        //display image
        self.photoDisplayPath = "photoDisplayPath" <~~ json
        
        //phoneNumber
        self.phoneNumber = "phoneNumber" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
//        
//        guard let id = self.id else {
//            return nil
//        }
        
        return jsonify([
            "id" ~~> id,
            "fullName" ~~> self.fullName,
            "email" ~~> self.email,
            "password" ~~> self.password,
            "phoneNumber" ~~> self.phoneNumber,
            "photoDisplayPath" ~~> self.photoDisplayPath
            ])
    }
}
