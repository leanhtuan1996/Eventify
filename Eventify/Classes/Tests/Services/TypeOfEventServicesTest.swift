//
//  TypeOfEventServicesTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/9/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import Firebase

let refEventTypesTest = Firestore.firestore().collection("EventTypes")

class TypeOfEventServicesTest: NSObject {
    static let shared = TypeOfEventServicesTest()
    
    func getTypesEvent(completionHandler: @escaping (_ types: [TypeObjectTest]?, _ error: String?) -> Void) {
        var eventTypes: [TypeObjectTest] = []
        
        refEventTypesTest.getDocuments { (snapshot, error) in
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
                    if let typeEvent = TypeObjectTest(json: doc.data()) {
                        eventTypes.append(typeEvent)
                    }
                }
            })
            
            completionHandler(eventTypes, nil)
        }
    }
}
