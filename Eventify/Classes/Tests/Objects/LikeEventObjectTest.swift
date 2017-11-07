//
//  LikeEventObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class LikeEventObjectTest: NSObject, Glossy {
    var id: String
    var idEvent: String?
    var idUser: String?
    var dateLiked: Int?
    
    override init() {
        super.init()
        self.id = ""
    }
    
    required init?(json: JSON) {
        
        //Id has not nil
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        
        
        //idEvent
        self.idEvent = "idEvent" <~~ json
        
        //idUser
        self.idUser = "idUser" <~~ json
        
        //dateLiked
        self.dateLiked = "dateLiked" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
        guard let id = self.id else {
            return nil
        }
        
        return jsonify([
            "id" ~~> id,
            "idEvent" ~~> self.idEvent,
            "idUser" ~~> self.idUser,
            "dateLiked" ~~> self.dateLiked
            ])
    }

}
