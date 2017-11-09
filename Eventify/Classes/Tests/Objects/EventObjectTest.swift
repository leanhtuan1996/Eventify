//
//  EventObjectTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class EventObjectTest: NSObject, Glossy {
    var id: String
    var name: String?
    var address: AddressObjectTest?
    var dateCreated: Int?
    var dateEdited: Int?
    var photoCoverPath: String?
    var descriptionEvent: String?
    var createdBy: UserObjectTest?
    var timeStart: Int?
    var timeEnd: Int?
    var types: [TypeObjectTest]?
    var tickets: [TicketObjectTest]?
    var liked: [LikeEventObjectTest]?
    var ordered: [OrderTicketObject]?
    
    
    override init() {
        
        self.id = ""
        
        super.init()
    }
    
    required init?(json: JSON) {
        
        //Id has not nil
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        
        //createdBy
        if let byUser: UserObjectTest = "createdBy" <~~ json {
            self.createdBy = byUser
        }
        
        //types
        if let typeJSON: [JSON] = "types" <~~ json {
            self.types = [TypeObjectTest].from(jsonArray: typeJSON)
        }
        
        //tickets
        if let ticketJSON: [JSON] = "tickets" <~~ json {
            self.tickets = [TicketObjectTest].from(jsonArray: ticketJSON)
        }
        
        //time to start event
        if let timeStart: Int = "timeStart" <~~ json {
            self.timeStart = timeStart
        }
        
        //time to stop event
        if let timeEnd: Int = "timeEnd" <~~ json {
            self.timeEnd = timeEnd
        }
        
        //name of event
        self.name = "name" <~~ json
        
        //cover image for event
        self.photoCoverPath = "photoCoverPath" <~~ json
        
        //description of event
        self.descriptionEvent = "descriptions" <~~ json
        
        //address object for event
        if let address: AddressObjectTest = "address" <~~ json {
            self.address = address
        }
    }
    
    //to json
    func toJSON() -> JSON? {
//        
//        guard let id = self.id else {
//            return nil
//        }
        
        return jsonify([
            "id" ~~> id,
            "name" ~~> self.name,
            "address" ~~> self.address?.toJSON(),
            "descriptions" ~~> self.descriptionEvent,
            "photoCoverPath" ~~> self.photoCoverPath,
            "types" ~~> self.types?.toJSONArray(),
            "timeStart" ~~> self.timeStart,
            "timeEnd" ~~> self.timeEnd,
            "dateCreated" ~~> Helpers.getTimeStampWithInt(),
            "dateEdited" ~~> self.dateEdited
            ])
    }

}
