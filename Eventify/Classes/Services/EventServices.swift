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

class EventServices: NSObject {
    static let shared = EventServices()
    //ref User child
    let refUser = Database.database().reference().child("Events")
    
    func getEvents() {
        
    }
    
    func getEvent(withId id: String) {
        
    }
    
    func getDetailEvent(withId id: String) {
        
    }
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent() {
        
    }
    
    func deleteEvent(withId id: String) {
        
    }
    
    func updateEvent(withId id: String) {
        
    }
}
