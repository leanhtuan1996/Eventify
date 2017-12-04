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
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        self.id = id
        
        
        //orders
        if let orderBy: UserObjectTest = "orderby" <~~ json {
            self.orderBy = orderBy
        }
        
        //tickets 
        if let ticketJson: [JSON] = "tickets" <~~ json {
            if let ticketsArray = [TicketOrderObjectTest].from(jsonArray: ticketJson) {
                self.ticketsOrder = ticketsArray
            }
        }
        
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
            "_id" ~~> id,
            "dateCreated" ~~> self.dateCreated,
            "idEvent" ~~> self.idEvent,
            "tickets" ~~> self.ticketsOrder?.toJSONArray(),
            "fullName" ~~> self.fullName,
            "phoneNumber" ~~> self.phoneNumber
            ])
    }
}
