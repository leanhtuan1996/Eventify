//
//  EventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Gloss

class EventServices: NSObject {
    static let shared = EventServices()
    //ref User child
    let refEvent = Database.database().reference().child("Events")
    
    func getEvents(completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void ) {
        //listen
        
        var events: [EventObject] = []
        
        refEvent.observe(.value, with: { (data) in
            events = []
            guard let json = data.value as? JSON else {
                return completionHandler(nil, "Data invalid format")
            }
            
            for object in json {
                if let eventsJSON = object.value as? JSON {
                    if let event = EventObject(json: eventsJSON) {
                        events.append(event)
                    }
                }
            }
            
            completionHandler(events, nil)
         
        })
        
        
    }
    
    func getEvent(withId id: String, completionHandler: @escaping (_ event: EventObject?, _ error: String?) -> Void)  {
        refEvent.child(id).observeSingleEvent(of: .value, with: { (data) in
            guard let json = data.value as? JSON else {
                return completionHandler(nil, "Data invalid format")
            }
            
            if let event = EventObject(json: json) {
                return completionHandler(event, nil)
            }
            
            return completionHandler(nil, "Get Event Error")
            
        })
    }
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
        
//        
//        refEvent.childByAutoId().setValue()
    }
    
    func deleteEvent(withId id: String) {
        refEvent.child(id).removeValue()
    }
    
    func updateEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
//        if let id = event.id {
//            refEvent.child(id).setValue(event.toJSON())
//        }
//        refEvent.child("1").updateChildValues(event.toJSON()!) { (error, ref) in
//            
//        }
    }
}
