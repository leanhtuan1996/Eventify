//
//  TicketOrderObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketOrderObjectTest: NSObject, Glossy {
    var idTicket: String?
    var quantityBought: String?
    var QRCodeImgPath: String?
    
    override init() {
    }
    
    required init?(json: JSON) {
        
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
