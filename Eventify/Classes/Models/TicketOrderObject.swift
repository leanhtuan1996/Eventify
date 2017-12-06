//
//  TicketOrderObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketOrderObject: NSObject, Glossy {
    var id: String
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
        
        self.QRCodeImgPath = "QRCode" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
        return jsonify([
            "id" ~~> self.id,
            "QRCode" ~~> self.QRCodeImgPath
            ])
    }
    
}
