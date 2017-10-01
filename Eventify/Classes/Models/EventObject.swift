//
//  EventObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class EventObject: NSObject, Decodable {
    var id: String?
    var name: String?
    var photoURL: String?
    var by: UserObject?
    var descriptionEvent: String?
    var timeStart: String?
    var timeEnd: String?
    var address: String?
    var type: EventTypeObject?
    var ticket: [TicketObject]?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        
        if let byUser: UserObject = "by" <~~ json {
            self.by = byUser
        }
        
        if let type: EventTypeObject = "type" <~~ json {
            self.type = type
        }
        
        if let ticket: [TicketObject] = "tickets" <~~ json {
            self.ticket = ticket
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.photoURL = "photoURL" <~~ json
        self.descriptionEvent = "descriptionEvent" <~~ json
        self.timeStart = "timeStart" <~~ json
        self.timeEnd = "timeEnd" <~~ json
        self.address = "address" <~~ json
        
        
        
    }
}
