//
//  TicketObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss


class TicketObjectTest: NSObject, Glossy {
    var id: String
    var name: String?
    var descriptions: String?
    var createdBy: UserObjectTest?
    var dateCreated: Int?
    var quantitiesToSell: Int?
    var maxQuantitiesToOrder: Int = 10
    var price: Int?
    var quantitiesSold: Int?
    var quantitiesRemaining: Int?
    
    override init() {
        self.id = ""
    }
    
    required init?(json: JSON) {
        
        guard let id: String = "id" <~~ json else {
            return nil
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.descriptions = "descriptions" <~~ json
        self.quantitiesToSell = "quantitiesToSell" <~~ json
        self.dateCreated = "dateCreated" <~~ json
        
        //createdBy
        if let byUser: UserObjectTest = "createdBy" <~~ json {
            self.createdBy = byUser
        }
        
        if let maxQuantitiesToOrder: Int = "maxQuantitiesToOrder" <~~ json {
            self.maxQuantitiesToOrder = maxQuantitiesToOrder
        }
        
        self.price = "price" <~~ json
        self.quantitiesSold = "quantitiesSold" <~~ json
        self.quantitiesRemaining = "quantitiesRemaining" <~~ json
    }
    
    func toJSON() -> JSON? {
        
        guard let id = self.id else {
            return nil
        }
        
        return jsonify(
            ["id" ~~> id,
             "name" ~~> self.name,
             "descriptions" ~~> self.descriptions,
             "quantitiesToSell" ~~> self.quantitiesToSell,
             "dateCreated" ~~> self.dateCreated,
             "maxQuantitiesToOrder" ~~> self.maxQuantitiesToOrder,
             "price" ~~> self.price,
             "quantitiesSold" ~~> self.quantitiesSold,
             "quantitiesRemaining" ~~> self.quantitiesRemaining
            ])
    }
    
}
