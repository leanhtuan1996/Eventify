//
//  OrderObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderObjectTest: NSObject, Glossy {
    var id: String
    var orderBy: UserObjectTest?
    var dateCreated: Int?
    var ticketsOrder: [TicketOrderObjectTest]?
    var idEvent: String?
    var fullName: String?
    var phoneNumber: String?
    
    override init() {
        self.id = ""
        super.init()
    }
    
    required init?(json: JSON) {
        
        //Id has not nil
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        
        
        //orders
        //        if let orderByJSON: [JSON] = "orderBy" <~~ json {
        //            self.orderBy = [UserObjectTest].from(jsonArray: orderByJSON)
        //        }
        
        //dateCreated
        self.dateCreated = "dateCreated" <~~ json
        
        //idEvent
        self.idEvent = "idEvent" <~~ json
        
        //display fullName
        self.fullName = "fullName" <~~ json
        
        //phoneNumber
        self.phoneNumber = "phoneNumber" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
        return jsonify([
            "id" ~~> id,
            "dateCreated" ~~> self.dateCreated,
            "idEvent" ~~> self.idEvent,
            "fullName" ~~> self.fullName,
            "phoneNumber" ~~> self.phoneNumber
            ])
    }
}
