//
//  OrderObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderObject: NSObject, Glossy {
    var id: String
    var orderBy: UserObject?
    var dateCreated: Int?
    var ticketsOrder: [TicketOrderObject]?
    var event: EventObject?
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
        
        if let informations: JSON = "informations" <~~ json {
            if let phoneNumber = informations["phoneNumber"] as? Int {
                self.phoneNumber = phoneNumber.toString()
            }
            
            if let fullName = informations["fullName"] as? String {
                self.fullName = fullName
            }
        }
        
        //orders
        if let orderBy: UserObject = "orderby" <~~ json {
            self.orderBy = orderBy
        }
        
        //tickets
        if let ticketJson: [JSON] = "tickets" <~~ json {
            if let ticketsArray = [TicketOrderObject].from(jsonArray: ticketJson) {
                self.ticketsOrder = ticketsArray
            }
        }
        
        //dateCreated
        self.dateCreated = "dateCreated" <~~ json
        
        //idEvent
        //self.idEvent = "idEvent" <~~ json
        if let event: EventObject = "event" <~~ json {
            self.event = event
        }
    }
    
    //to json
    func toJSON() -> JSON? {
        
        return jsonify([
            "_id" ~~> id,
            "dateCreated" ~~> self.dateCreated,
            "idEvent" ~~> self.event?.id,
            "tickets" ~~> self.ticketsOrder?.toJSONArray(),
            "fullName" ~~> self.fullName,
            "phoneNumber" ~~> self.phoneNumber
            ])
    }
}
