//
//  TicketOrderObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketOrderObjectTest: NSObject, Glossy {
    var id: String
    var idTicket: String?
    var quantityBought: String?
    var QRCodeImgPath: String?
    
    override init() {
        self.id = ""
        super.init()
    }
    
    required init?(json: JSON) {
        
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        
        self.id = id
        
        self.idTicket = "idTicket" <~~ json
        
        self.quantityBought = "quantityBought" <~~ json
        
        self.QRCodeImgPath = "QRCodeImgPath" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
        return jsonify([
            "idTicket" ~~> self.idTicket,
            "quantityBought" ~~> self.quantityBought,
            "QRCodeImgPath" ~~> self.QRCodeImgPath
            ])
    }
    
}
