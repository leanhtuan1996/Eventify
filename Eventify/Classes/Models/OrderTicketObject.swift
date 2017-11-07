//
//  OrderTicketObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderTicketObject: NSObject, Glossy {
    var id: String?
    var idEvent: String?
    var idUserBuy: String?
    var tickets: [TicketObject]?
    var nameBuy: String?
    var phone: String?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        
        self.id = id
        
        if let tickets: [JSON] = "tickets" <~~ json {
            self.tickets = [TicketObject].from(jsonArray: tickets)
        }
        
        self.idEvent = "idEvent" <~~ json
        self.idUserBuy = "idUserBuy" <~~ json
        self.nameBuy = "nameBuy" <~~ json
        self.phone = "phone" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "tickets" ~~> self.tickets?.toJSONArray(),
            "idEvent" ~~> self.idEvent,
            "idUserBuy" ~~> self.idUserBuy,
            "nameBuy" ~~> self.nameBuy,
            "phone" ~~> self.phone
            ])
    }
    
}
