//
//  UserObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class UserObject: NSObject, Gloss.Decodable {
    var id: String
    var email: String
    var password: String?
    var fullName: String?
    var address: String?
    var phone: String?
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
        self.password = ""
    }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json, let email: String =  "email" <~~ json else {
            return nil
        }
        self.id = id
        self.email = email
        self.password = "password" <~~ json ?? ""
        self.fullName = "fullName" <~~ json ?? ""
        self.address = "address" <~~ json ?? ""
        self.phone = "phone" <~~ json ?? ""
    }
}
