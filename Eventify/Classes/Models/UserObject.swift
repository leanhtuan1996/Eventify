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
    
    override init() {
        self.id = ""
    }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        self.email = "email" <~~ json ?? nil
        self.password = "password" <~~ json ?? nil
        self.fullName = "fullName" <~~ json ?? nil
        self.address = "address" <~~ json ?? nil
        self.phone = "phone" <~~ json ?? nil
        self.photoURL = "photoURL" <~~ json ?? nil
    }
    
    func toJSON() -> JSON? {
        return jsonify(
            ["id" ~~> self.id,
             "email" ~~> self.email,
             "password" ~~> self.password,
             "fullName" ~~> self.fullName,
             "address" ~~> self.address,
             "phone" ~~> self.phone,
             "photoURL" ~~> self.photoURL
            ])
    }
}
