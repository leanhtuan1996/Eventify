//
//  EventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Gloss

let refEventTest = Firestore.firestore().collection("Events")

class EventServicesTest: NSObject {
    static let shared = EventServicesTest()
    //ref User child
    
    var lastSnapshotEvent: DocumentSnapshot?
    
    func getEvents(completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void ) {
        
        //default
        var refQuery = refEventTest.order(by: "dateCreated", descending: false).limit(to: 15)
        
        if let lastSnapshotEvent = self.lastSnapshotEvent {
            refQuery = refEventTest.order(by: "dateCreated", descending: false).start(afterDocument: lastSnapshotEvent).limit(to: 15)
        }
        
        refQuery.addSnapshotListener { (snapshot, error) in
            var events: [EventObject] = []
            
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            } else {
                guard let snapshot = snapshot else {
                    print("Data not found")
                    return completionHandler(nil, "Data not found")
                }
                
                if let last = snapshot.documents.last {
                    self.lastSnapshotEvent = last
                }
                
                for document in snapshot.documents {
                    
                    print(document.data())
                    if let event = EventObject(json: document.data()) {
                        events.append(event)
                    }
                }
                
                completionHandler(events, nil)
            }
        }

    }
    
    //Done
    func getEvent(withId id: String, completionHandler: @escaping (_ event: EventObject?, _ error: String?) -> Void)  {
        
        refEventTest.document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let data = snapshot else {
                print("Data not found")
                return completionHandler(nil, "Data not found")
            }
            
            if let event = EventObject(json: data.data()) {
                completionHandler(event, nil)
            } else {
                completionHandler(nil, "Cast json to object has been failed")
            }
            
        }
    }
    
    func deleteEvents() {
        refEventTest.document("OHtrA5mvouboda7mgoaZ").delete()
    }
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        let newEventRef = refEventTest.document()
        event.id = newEventRef.documentID
        
        if event.name == nil {
            return completionHandler("Tên sự kiện không được rỗng")
        }
        
        if event.tickets == nil || event.tickets?.count == 0 {
            return completionHandler("Vé sự kiện không được rỗng")
        }
        
        if event.timeEnd == nil || event.timeStart == nil {
            return completionHandler("Thời gian bắt đầu hoặc kết thúc không được rỗng")
        }
        
        if event.types == nil || event.types?.count == 0 {
            return completionHandler("Loại sự kiện không được rỗng")
        }
        
        guard let eventJSON = event.toJSON() else {
            return completionHandler("Dữ liệu không hợp lệ")
        }
        
//        newEventRef.setData(eventJSON) { (error) in
//            return completionHandler(error)
//        }
        
        newEventRef.setData(eventJSON) { err in
            if let error = err {
                return completionHandler(error.localizedDescription)
            } else {
                return completionHandler(nil)
            }
        }
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
    
    func uploadImageCover(data imgData: Data, completionHandler: @escaping (_ urlImg: String?, _ error: String?) -> Void ) {
        let timeStamp = Helpers.getTimeStamp()
        guard let currentUser = UserServices.shared.currentUser else {
            return completionHandler(nil, "User not found")
        }
        
        let keyPath = "\(currentUser.id)" + "\(timeStamp).jpg"
        
        let uploadTask = refImageEventStorage.child(keyPath).putData(imgData, metadata: nil) { (metaData, error) in
            guard let metaData = metaData else {
                return completionHandler(nil, "MetaData not found")
            }
            
            if let url = metaData.downloadURL() {
                return completionHandler(String(describing: url), nil)
            }
            
            
        }
        
        uploadTask.resume()
        
    }
}
