//
//  UserObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class UserObjectTest: NSObject, Glossy {
    var id: String
    var fullName: String?
    var password: String?
    var email: String?
    var photoDisplayPath: String?
    var phoneNumber: String?
    var orders: [OrderObjectTest]?
    var liked: [LikeEventObjectTest]?
    
    override init() {
        self.id = ""
    }
    
    required init?(json: JSON) {
        
        //Id has not nil
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        
        
        //orders
        if let ordersJSON: [JSON] = "orders" <~~ json {
            self.orders = [OrderObjectTest].from(jsonArray: ordersJSON)
        }
        
        //liked
        if let likedJSON: [JSON] = "liked" <~~ json {
            self.liked = [LikeEventObjectTest].from(jsonArray: likedJSON)
        }
        
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
        
        return jsonify([
            "id" ~~> self.id,
            "fullName" ~~> self.fullName,
            "email" ~~> self.email,
            "phoneNumber" ~~> self.phoneNumber,
            "photoDisplayPath" ~~> self.photoDisplayPath
            ])
    }
}
