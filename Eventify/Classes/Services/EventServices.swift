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
import Haneke

let refEvent = Firestore.firestore().collection("Events")
let refImageEventStorage = Storage.storage().reference().child("Images").child("EventCover")

class EventServices: NSObject {
    static let shared = EventServices()
    //ref User child
    
    var lastSnapshotEvent: DocumentSnapshot?
    
    var allEvents: [EventObject] = []
    
    func getEvents(isFirstLoad: Bool, completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void ) {
        
        var refQuery: Query?
        
        if isFirstLoad {
            self.allEvents = []
            self.lastSnapshotEvent = nil
            refQuery = refEvent.order(by: "dateCreated", descending: true).limit(to: 15)
        } else {
            if let lastSnapshotEvent = self.lastSnapshotEvent {
                refQuery = refEvent.order(by: "dateCreated", descending: true).start(afterDocument: lastSnapshotEvent).limit(to: 15)
            }
        }
        
        refQuery?.addSnapshotListener { (snapshot, error) in
            
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
                    if let event = EventObject(json: document.data()) {
                        self.allEvents.append(event)
                    }
                }
                
                return completionHandler(self.allEvents, nil)
            }
        }
        
    }
    
    //Done
    func getEvent(withId id: String, completionHandler: @escaping (_ event: EventObject?, _ error: String?) -> Void)  {
        
        refEvent.document(id).addSnapshotListener { (snapshot, error) in
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
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        let newEventRef = refEvent.document()
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
        
        newEventRef.setData(eventJSON) { err in
            if let error = err {
                return completionHandler(error.localizedDescription)
            } else {
                return completionHandler(nil)
            }
        }
    }
    
    func deleteEvents() {
        refEvent.getDocuments { (snapshot, error) in
            let batch = refEvent.firestore.batch()
            snapshot?.documents.forEach({ batch.deleteDocument($0.reference) })
            
            batch.commit(completion: { (error) in
                
            })
        }
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
        
        guard let currentUser = UserServices.shared.currentUser else {
            return completionHandler(nil, "User not found")
        }
        
        let keyPath = "\(currentUser.id)" + "\(Helpers.getTimeStamp()).jpg"
        
        let uploadTask = refImageEventStorage.child(keyPath).putData(imgData, metadata: nil) { (metaData, error) in
            guard let metaData = metaData else {
                return completionHandler(nil, "MetaData not found")
            }
            
            return completionHandler(metaData.path, nil)
        }
        
        uploadTask.resume()
        
    }
    
    func downloadImageCover(withPath path: String, completionHandler: @escaping (_ url: URL?, _ error: Error?) -> Void ) {
        
        refStorage.reference(withPath: path).downloadURL { (url, error) in
            return completionHandler(url, error)
        }
    }
}
