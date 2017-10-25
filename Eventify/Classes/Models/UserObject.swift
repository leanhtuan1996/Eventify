//
//  UserObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class UserObject: NSObject, Glossy {
    var id: String
    var email: String?
    var password: String?
    var fullName: String?
    var address: String?
    var phone: String?
    var photoURL: String?
    var token: String?
    var dob: String?
    
    override init() {
        self.id = ""
    }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        self.email = "email" <~~ json
        self.password = "password" <~~ json
        self.fullName = "fullName" <~~ json
        
        //for zalo
        self.fullName = "name" <~~ json
        self.dob = "birthday" <~~ json
        
        
        self.address = "address" <~~ json
        self.phone = "phone" <~~ json
        self.photoURL = "photoURL" <~~ json
        self.token = "token" <~~ json
        self.dob  = "dob" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify(
            ["id" ~~> self.id,
             "email" ~~> self.email,
             "password" ~~> self.password,
             "fullName" ~~> self.fullName,
             "address" ~~> self.address,
             "phone" ~~> self.phone,
             "photoURL" ~~> self.photoURL,
             "dob" ~~> self.dob,
             "token" ~~> self.token
            ])
    }
}
