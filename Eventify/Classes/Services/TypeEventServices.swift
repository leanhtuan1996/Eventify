//
//  TypeEventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import Firebase

let refEventTypes = Firestore.firestore().collection("EventTypes")

class TypeEventServices: NSObject {
    static let shared = TypeEventServices()
    
    func getTypesEvent(completionHandler: @escaping (_ types: [EventTypeObject]?, _ error: String?) -> Void) {
        var eventTypes: [EventTypeObject] = []
        
        refEventTypes.getDocuments { (snapshot, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let snapshot = snapshot else {
                return completionHandler(nil, "Snapshot not found")
            }
            
            if snapshot.isEmpty {
                return completionHandler(eventTypes, nil)
            }
            
            snapshot.documents.forEach({ (doc) in
                if doc.exists {
                    if let typeEvent = EventTypeObject(json: doc.data()) {
                        eventTypes.append(typeEvent)
                    }
                }
            })
            
            completionHandler(eventTypes, nil)
        }
    }
}
