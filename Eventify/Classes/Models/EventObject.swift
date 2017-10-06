//
//  EventObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import FirebaseDatabase


class EventObject: NSObject, Glossy  {
    var id: String?
    var name: String?
    var photoURL: String?
    var by: UserObject?
    var descriptionEvent: String?
    var timeStart: Int?
    var timeEnd: Int?
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
        if let ticketJSON: [JSON] = "tickets" <~~ json {
            self.tickets = [TicketObject].from(jsonArray: ticketJSON)
        }
        
        if let timeStart: Int = "timeStart" <~~ json {
            self.timeStart = timeStart
        }
        
        if let timeEnd: Int = "timeEnd" <~~ json {
            self.timeEnd = timeEnd
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.photoURL = "photoURL" <~~ json
        self.descriptionEvent = "descriptionEvent" <~~ json
        self.address = "address" <~~ json
    }
    
    //to json
    func toJSON() -> JSON? {
        
        guard let tickets = self.tickets, let id = self.id else {
            return nil
        }
        
        //set id for ticket
        for ticket in tickets {
            let id = refEvent.child(id).child("tickets").childByAutoId().key
            ticket.id = id
        }
        
        return jsonify([
            "id" ~~> self.id,
            "name" ~~> self.name,
            "address" ~~> self.address,
            "by" ~~> self.by?.toJSON(),
            "photoURL" ~~> self.photoURL,
            "tickets" ~~> self.tickets?.toJSONArray(),
            "types" ~~> self.types?.toJSONArray(),
            "timeStart" ~~> self.timeStart,
            "timeEnd" ~~> self.timeEnd
            ])
    }
    
    
}
