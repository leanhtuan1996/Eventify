//
//  EventObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class EventObject: NSObject, Glossy  {
    var id: String?
    var name: String?
    var photoURL: String?
    var by: UserObject?
    var descriptionEvent: String?
    var timeStart: String?
    var timeEnd: String?
    var address: String?
    var types: [EventTypeObject]?
    var tickets: [TicketObject]?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        
        if let byUser: UserObject = "by" <~~ json {
            self.by = byUser
        }
        

        //types
        if let typeJSON: JSON = "types" <~~ json {
            var typeArray: [EventTypeObject] = []
            for temp in typeJSON {
                if let typeJson = temp.value as? JSON {
                    if let typeObject = EventTypeObject(json: typeJson) {
                        typeArray.append(typeObject)
                    }
                }
            }
            
            self.types = typeArray
        }
        
        //tickets
        if let ticketJSON: JSON = "tickets" <~~ json {
            var ticketArray: [TicketObject] = []
            for temp in ticketJSON {
                if let ticketjson = temp.value as? JSON {
                    if let ticketObject = TicketObject(json: ticketjson) {
                        ticketArray.append(ticketObject)
                    }
                }
            }
            
            self.tickets = ticketArray
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
    
    //to json
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "name" ~~> self.name,
            "address" ~~> self.address,
            "by" ~~> self.by,
            "photoURL" ~~> self.photoURL,
            "tickets" ~~> self.tickets,
            "types" ~~> self.types,
            "timeStart" ~~> self.timeStart,
            "timeEnd" ~~> self.timeEnd
            ])
    }
    
    
}
