//
//  TypeEventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import FirebaseDatabase

let refEventTypes = Database.database().reference().child("EventTypes")
class TypeEventServices: NSObject {
    static let shared = TypeEventServices()
    
    func getTypesEvent(completionHandler: @escaping (_ types: [EventTypeObject]?, _ error: String?) -> Void) {
        var eventTypes: [EventTypeObject] = []
        refEventTypes.observe(.value, with: { (data) in
            eventTypes = []
            guard let json = data.value as? JSON else {
                return completionHandler(nil, "Data invalid format")
            }
            
            for object in json {
                if let eventTypesJSON = object.value as? JSON {
                    if let type = EventTypeObject(json: eventTypesJSON) {
                        eventTypes.append(type)
                    }
                }
            }
            
            completionHandler(eventTypes, nil)
        })
    }
}
