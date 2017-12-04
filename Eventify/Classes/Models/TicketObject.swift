//
//  TicketObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketObject: NSObject, Glossy {
    var id: String
    var name: String?
    var descriptions: String?
    var createdBy: UserObject?
    var dateCreated: Int?
    var quantity: Int?
    var maxToOrder: Int = 10
    var price: Int?
    var quantitiesSold: Int?
    var quantitiesRemaining: Int?
    
    override init() {
        self.id = ""
        super.init()
    }
    
    required init?(json: JSON) {
        
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.descriptions = "description" <~~ json
        self.quantity = "quantity" <~~ json
        self.dateCreated = "dateCreated" <~~ json
        
        //createdBy
        if let byUser: UserObject = "createdBy" <~~ json {
            self.createdBy = byUser
        }
        
        if let maxToOrder: Int = "maxToOrder" <~~ json {
            self.maxToOrder = maxToOrder
        }
        
        self.price = "price" <~~ json
        self.quantitiesSold = "quantitiesSold" <~~ json
        self.quantitiesRemaining = "quantitiesRemaining" <~~ json
    }
    
    func toJSON() -> JSON? {        
        return jsonify(
            ["_id" ~~> id,
             "name" ~~> self.name,
             "description" ~~> self.descriptions,
             "quantity" ~~> self.quantity,
             "dateCreated" ~~> self.dateCreated,
             "maxToOrder" ~~> self.maxToOrder,
             "price" ~~> self.price,
             "quantitiesSold" ~~> self.quantitiesSold,
             "quantitiesRemaining" ~~> self.quantitiesRemaining
            ])
    }
}
