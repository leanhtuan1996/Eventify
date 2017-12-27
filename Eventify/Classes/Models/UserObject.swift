//
//  UserObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class UserObject: NSObject, Glossy {
    var id: String
    var fullName: String?
    var password: String?
    var email: String?
    var token: String?
    var photoDisplayPath: String?
    var phoneNumber: String?
    var orders: [OrderObject]?
    var liked: [EventObject]?
    
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
//        if let ordersJSON: [JSON] = "orders" <~~ json {
//            self.orders = [OrderObject].from(jsonArray: ordersJSON)
//        }
        
        //liked
//        if let liked: [EventObject] = "liked" <~~ json {
//            //self.liked = [LikeEventObjectTest].from(jsonArray: likedJSON)
//            self.liked = liked
//        }
        
        //token
        self.token = "token" <~~ json
        
        //full name
        self.fullName = "fullName" <~~ json
        
        //email
        self.email = "email" <~~ json
        
        //display image
        self.photoDisplayPath = "photoPath" <~~ json
        
        //phoneNumber
        self.phoneNumber = "phoneNumber" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
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
