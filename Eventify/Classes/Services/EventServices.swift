//
//  EventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Gloss

let refEvent = Database.database().reference().child("Events")
let refImageEventStorage = Storage.storage().reference().child("Images").child("EventCover")
class EventServices: NSObject {
    static let shared = EventServices()
    //ref User child
    
    
    
    //get 10 events that newest
    func getEvents(firstId: String?, completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void ) {
        //listen
        
        var events: [EventObject] = []
        
        
        refEvent.queryOrdered(byChild: "dateCreated")
            .queryLimited(toFirst: 15).observe(.value, with: { (snapshot) in
                
                events = []
                
                print("LOADING MORE EVENTS")
                
                print(snapshot.children.allObjects.count)
                
                for child in snapshot.children {
                    
                    guard let json = child as? DataSnapshot else {
                        return completionHandler(nil, "Data invalid format")
                    }
                    
                    if let eventJSON = json.value as? JSON {
                        if let event = EventObject(json: eventJSON) {
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
        let id = refEvent.childByAutoId().key
        event.id = id
        
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
        
        refEvent.child(id).setValue(eventJSON)
        
        return completionHandler(nil)
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
