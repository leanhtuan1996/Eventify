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
        
//        if let ticket: [TicketObject] = "tickets" <~~ json {
//            print(ticket.count)
//            self.ticket = ticket
//        }
        
        
        
        if let ticketJSON: JSON = "tickets" <~~ json {
            var ticketArray: [TicketObject] = []
            for temp in ticketJSON {
                if let ticketjson = temp.value as? JSON {
                    if let ticketObject = TicketObject(json: ticketjson) {
                        ticketArray.append(ticketObject)
                    }
                }
            }
            
            self.ticket = ticketArray
        }
        
        if let timeStart: Int = "timeStart" <~~ json {
            self.timeStart = timeStart.toString()
        }
        
        if let timeEnd: Int = "timeEnd" <~~ json {
            self.timeEnd = timeEnd.toString()
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.photoURL = "photoURL" <~~ json
        self.descriptionEvent = "descriptionEvent" <~~ json
        self.address = "address" <~~ json
        
        
        
    }
}
