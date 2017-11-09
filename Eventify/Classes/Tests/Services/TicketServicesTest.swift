//
//  TicketServicesTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/9/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import FirebaseFirestore

let refTicketTest = Firestore.firestore().collection("Tickets")

class TicketServicesTest: NSObject {
    static let shared = TicketServicesTest()
    
    func getTickets(isListen: Bool, completionHandler: @escaping (_ tickets: [TicketObjectTest]?, _ error: String?) -> Void ) {
        
        guard let userId = UserServicesTest.shared.currentUser?.id else {
            print("User id not found")
            return completionHandler(nil, "User id not found")
        }
        
        if isListen {
            refTicketTest.document(userId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    return completionHandler(nil, error.localizedDescription)
                }
                
                guard let snapshotDoc = snapshot, snapshotDoc.exists else {
                    return completionHandler(nil, "Snapshot not found")
                }
                
                var tickets: [TicketObjectTest] = []
                
                snapshotDoc.data().forEach({ (ticket, value) in
                    
                    //print(ticket)
                    
                    guard let ticketJson = value as? JSON else {
                        return completionHandler(nil, "Convert value to json have been failed")
                    }
                    
                    if let ticket = TicketObjectTest(json: ticketJson) {
                        tickets.append(ticket)
                    }
                })
                
                completionHandler(tickets, nil)
                
            }
        } else {
            refTicketTest.document(userId).getDocument { (snapshot, error) in
                
                if let error = error {
                    return completionHandler(nil, error.localizedDescription)
                }
                
                guard let snapshotDoc = snapshot else {
                    return completionHandler([], nil)
                }
                
                if !snapshotDoc.exists {
                    return completionHandler(nil, nil)
                }
                
                var tickets: [TicketObjectTest] = []
                
                snapshotDoc.data().forEach({ (ticket, value) in
                    
                    guard let ticketJson = value as? JSON else {
                        return completionHandler(nil, "Convert value to json have been failed")
                    }
                    
                    if let ticket = TicketObjectTest(json: ticketJson) {
                        tickets.append(ticket)
                    }
                })
                
                return completionHandler(tickets, nil)
            }
        }
    }
    
    func getTicket(withId id: String, completionHandler: @escaping (_ ticket: TicketObjectTest?, _ error: String?) -> Void) {
        
    }
    
    func addTicket(with ticket: TicketObjectTest, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let userId = UserServicesTest.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        guard let ticketJson = ticket.toJSON() else     {
            return completionHandler("Convert ticket object to json has been failed")
        }
        
        let id = "\(userId)\(Helpers.getTimeStamp())"
        ticket.id = id
        
        refTicketTest.document(userId).setData([id : ticketJson], options: SetOptions.merge()) { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
    func editTicket(with ticket: TicketObjectTest, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let userId = UserServicesTest.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
                
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket to json has been failed")
        }
        
        refTicketTest.document(userId).updateData([ticket.id : ticketJson]) { (error) in
            return completionHandler(error?.localizedDescription)
        }
        
    }
    
    func deleteTicket(withId id: String, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let userId = UserServicesTest.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        
        refTicketTest.document(userId).updateData([id : FieldValue.delete()]) { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
}

