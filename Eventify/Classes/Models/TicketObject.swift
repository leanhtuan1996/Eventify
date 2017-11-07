//
//  TicketObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketObject: NSObject, Glossy {
    var id: String?
    var name: String?
    var descriptions: String?
    var quantity: Int?
    var price: Int?
    var sold: Int?
    var remain: Int?
    
    override init() {
        
    }
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
        self.descriptions = "descriptions" <~~ json
        self.quantity = "quantity" <~~ json
        self.price = "price" <~~ json
        self.sold = "sold" <~~ json
        self.remain = "remain" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify(
            ["id" ~~> self.id,
             "quantity" ~~> self.quantity,
             "price" ~~> self.price,
             "name" ~~> self.name,
             "descriptions" ~~> self.descriptions,
             "sold" ~~> self.sold,
             "remain" ~~> self.remain
            ])
    }
    
}
