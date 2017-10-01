//
//  TicketObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketObject: NSObject, NSCoding, Decodable {
    var id: Int?
    var name: String?
    var descriptions: String?
    var quantity: Int?
    var price: Int?
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        descriptions = aDecoder.decodeObject(forKey: "descriptions") as? String ?? ""
        quantity = aDecoder.decodeInteger(forKey: "quantity")
        price = aDecoder.decodeInteger(forKey: "price")
        super.init()
    }
    
    required init?(json: JSON) {
        self.name = "name" <~~ json
        self.descriptions = "descriptions" <~~ json
        self.quantity = "quantity" <~~ json
        self.price = "price" <~~ json
    }
    
    func encode(with aCoder: NSCoder) {
        if let idInt = id {
            aCoder.encode(idInt, forKey: "id")
        }
        
        if let quantityInt = quantity {
            aCoder.encode(quantityInt, forKey: "quantity")
        }
        
        if let priceInt = price {
            aCoder.encode(priceInt, forKey: "price")
        }
        
        if let nameString = name {
            aCoder.encode(nameString, forKey: "name")
        }
        
        if let descriptionsString = descriptions {
            aCoder.encode(descriptionsString, forKey: "descriptions")
        }
    }
    
}
