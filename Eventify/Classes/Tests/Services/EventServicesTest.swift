//
//  EventServicesTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Gloss
import Haneke

let refEventTest = Firestore.firestore().collection("Events")
let refImageEventCoverStorageTest = Storage.storage().reference().child("Images").child("EventCover")
let refImageEventDiscriptionsStorageTest = Storage.storage().reference().child("Images").child("EventDescriptions")

class EventServicesTest: NSObject {
    static let shared = EventServicesTest()
    //ref User child
    
    var lastSnapshotEvent: DocumentSnapshot?
    var firstSnapshotEvent: DocumentSnapshot?
    
    var allEvents: [EventObjectTest] = []
    
    func getEvents(completionHandler: @escaping(_ events: [EventObjectTest]?, _ error: String?) -> Void) {
        let refQuery = refEvent.order(by: "dateCreated", descending: true).limit(to: 15)
        
        var events: [EventObjectTest] = []
        
        refQuery.addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            } else {
                guard let snapshot = snapshot else {
                    print("Data not found")
                    return completionHandler(nil, "Data not found")
                }
                
                self.lastSnapshotEvent = snapshot.documents.last
                
                for document in snapshot.documents {
                                       
                    guard let event = EventObjectTest(json: document.data()) else {
                        return completionHandler(nil, "Convert event json to object has been failed")
                    }
                    
                    //get tickets in subCollection
                    document.reference.collection("Tickets").addSnapshotListener({ (ticketSnapshot, error) in
                        
                        var tickets: [TicketObjectTest] = []
                        
                        if let error = error {
                            return completionHandler(nil, error.localizedDescription)
                        } else {
                            guard let ticketSnapshot = ticketSnapshot else {
                                return completionHandler(nil, "Data not found")
                            }
                            
                            for ticketDocument in ticketSnapshot.documents {
                                if let ticket = TicketObjectTest(json: ticketDocument.data()) {
                                    tickets.append(ticket)
                                }
                            }
                            
                            event.tickets = tickets
                            
                        }
                        
                        //get create by in subCollection
                        document.reference.collection("CreatedBy").addSnapshotListener({ (userSnapshot, error) in
                            if let error = error {
                                return completionHandler(nil, error.localizedDescription)
                            } else {
                                guard let userSnapshot = userSnapshot else {
                                    //print("Data not found")
                                    return completionHandler(nil, "Data not found")
                                }
                                
                                if let userDocument = userSnapshot.documents.first {
                                    if let user = UserObjectTest(json: userDocument.data()) {
                                        event.createdBy = user
                                    }
                                }
                            }
                        })
                        
                    })
                    
                    events.append(event)
                    
                }
                
                return completionHandler(events, nil)
            }
        }
        
    }
    
    func getMoreEvents(completionHandler: @escaping(_ events: [EventObjectTest]?, _ error: String?) -> Void ) {
        var refQuery: Query?
        if let lastSnapshotEvent = self.lastSnapshotEvent {
            refQuery = refEvent.order(by: "dateCreated", descending: true).start(afterDocument: lastSnapshotEvent).limit(to: 15)
        }
        var events: [EventObjectTest] = []
        refQuery?.addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            } else {
                guard let snapshot = snapshot else {
                    print("Data not found")
                    return completionHandler(nil, "Data not found")
                }
                
                self.lastSnapshotEvent = snapshot.documents.last
                
                for document in snapshot.documents {
                    //print(document.data())
                    if let event = EventObjectTest(json: document.data()) {
                        events.append(event)
                    }
                }
                
                return completionHandler(events, nil)
            }
        }
        
    }
    
    //Done
    func getEvent(withId id: String, completionHandler: @escaping (_ event: EventObjectTest?, _ error: String?) -> Void)  {
        
        refEvent.document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let data = snapshot else {
                print("Data not found")
                return completionHandler(nil, "Data not found")
            }
            
            if let event = EventObjectTest(json: data.data()) {
                completionHandler(event, nil)
            } else {
                completionHandler(nil, "Cast json to object has been failed")
            }
            
        }
    }
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent(withEvent event: EventObjectTest, completionHandler: @escaping (_ error: String?) -> Void) {
        let newEventRef = refEvent.document()
        event.id = newEventRef.documentID
        
        let subTickets = newEventRef.collection("Tickets")
        let subCreatedBy = newEventRef.collection("CreatedBy")
        
        if event.name == nil {
            return completionHandler("Tên sự kiện không được rỗng")
        }
        
        guard let tickets = event.tickets, tickets.count > 0 else {
            return completionHandler("Vé sự kiện không được rỗng")
        }
        
        if event.timeStart == nil || event.timeStart == nil {
            return completionHandler("Thời gian bắt đầu hoặc kết thúc không được rỗng")
        }
        
        if event.types == nil || event.types?.count == 0 {
            return completionHandler("Loại sự kiện không được rỗng")
        }
        
        if event.address == nil {
            return completionHandler("Địa chỉ sự kiện không được rỗng")
        }
        
        guard let eventJSON = event.toJSON() else {
            return completionHandler("Dữ liệu không hợp lệ")
        }
        
        
        let batch = Firestore.firestore().batch()
        
        batch.setData(eventJSON, forDocument: newEventRef, options: SetOptions.merge())
        
        //tickets
        tickets.forEach { (ticket) in
            let newSubTicket = subTickets.document(ticket.id)
            
            guard let ticketJson = ticket.toJSON() else {
                return completionHandler("Convert ticket object to json has been failed")
            }
            
            batch.setData(ticketJson, forDocument: newSubTicket, options: SetOptions.merge())
        }
        
        //createdBy
        guard let createdBy = event.createdBy else {
            return completionHandler("User not found")
        }
        
        guard let userJson = createdBy.toJSON() else {
            return completionHandler("Convert user to json has been failed")
        }
        
        let newSubCreatedBy = subCreatedBy.document(createdBy.id)
        batch.setData(userJson, forDocument: newSubCreatedBy)
        
        
//        newEventRef.setData(eventJSON) { err in
//            if let error = err {
//                return completionHandler(error.localizedDescription)
//            } else {
//                return completionHandler(nil)
//            }
//        }
        
        batch.commit { (error) in
            return completionHandler(error?.localizedDescription)
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
        
        guard let currentUser = UserServicesTest.shared.currentUser else {
            return completionHandler(nil, "User not found")
        }
        
        let keyPath = "\(currentUser.id)" + "\(Helpers.getTimeStamp()).jpg"
        
        let uploadTask = refImageEventCoverStorage.child(keyPath).putData(imgData, metadata: nil) { (metaData, error) in
            guard let metaData = metaData else {
                return completionHandler(nil, "MetaData not found")
            }
            
            return completionHandler(metaData.path, nil)
        }
        
        uploadTask.resume()
        
    }
    
    func uploadImageDescriptionEvent(data imgData: Data, completionHandler: @escaping (_ urlImg: String?, _ error: String?) -> Void ) {
        
        guard let currentUser = UserServicesTest.shared.currentUser else {
            return completionHandler(nil, "User not found")
        }
        
        let keyPath = "\(currentUser.id)" + "\(Helpers.getTimeStamp()).jpg"
        
        refImageEventDiscriptionsStorage.child(keyPath).putData(imgData, metadata: nil) { (storage, error) in
            guard let metaData = storage else {
                return completionHandler(nil, "MetaData not found")
            }
            
            return completionHandler(metaData.downloadURL()?.absoluteString, nil)
        }
        
        //        let uploadTask = refImageEventDiscriptionsStorage.child(keyPath).putData(imgData, metadata: nil) { (metaData, error) in
        //            //print(metaData)
        //            guard let metaData = metaData else {
        //                return completionHandler(nil, "MetaData not found")
        //            }
        //
        //            return completionHandler(metaData.downloadURL()?.absoluteString, nil)
        //        }
        //
        //        uploadTask.resume()
        
    }
    
    func downloadImageCover(withPath path: String, completionHandler: @escaping (_ url: URL?, _ error: Error?) -> Void ) {
        
        refStorage.reference(withPath: path).downloadURL { (url, error) in
            return completionHandler(url, error)
        }
    }
}
