//
//  TicketServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import Gloss


let refTicket = Firestore.firestore().collection("Tickets")

class TicketServices: NSObject {
    static let shared = TicketServices()
    
    func getTickets(completionHandler: @escaping (_ tickets: [TicketObject]?, _ error: String?) -> Void ) {
        
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler(nil, "User id not found")
        }
        
        refTicket.document(userId).getDocument { (snapshot, error) in
            
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let snapshotDoc = snapshot else {
                return completionHandler([], nil)
            }
            
            if !snapshotDoc.exists {
                return completionHandler(nil, nil)
            }
            
            var tickets: [TicketObject] = []
            
            snapshotDoc.data().forEach({ (ticket, value) in
                
                guard let ticketJson = value as? JSON else {
                    return completionHandler(nil, "Convert value to json have been failed")
                }
                
                if let ticket = TicketObject(json: ticketJson) {
                    tickets.append(ticket)
                }
            })
            
            return completionHandler(tickets, nil)
        }
        //        refTicket.document(userId).addSnapshotListener { (snapshot, error) in
        //            if let error = error {
        //                return completionHandler(nil, error.localizedDescription)
        //            }
        //
        //            guard let snapshotDoc = snapshot, snapshotDoc.exists else {
        //                return completionHandler(nil, "Snapshot not found")
        //            }
        //
        //            var tickets: [TicketObject] = []
        //
        //            snapshotDoc.data().forEach({ (ticket, value) in
        //
        //                //print(ticket)
        //
        //                guard let ticketJson = value as? JSON else {
        //                    return completionHandler(nil, "Convert value to json have been failed")
        //                }
        //
        //                print(ticketJson)
        //
        //                if let ticket = TicketObject(json: ticketJson) {
        //                    tickets.append(ticket)
        //                }
        //            })
        //
        //            completionHandler(tickets, nil)
        //
        //        }
    }
    
    func getTicket(withId id: String, completionHandler: @escaping (_ ticket: TicketObject?, _ error: String?) -> Void) {
        
    }
    
    func addTicket(with ticket: TicketObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        guard let ticketJson = ticket.toJSON() else     {
            return completionHandler("Convert ticket object to json has been failed")
        }
        
        let id = "\(userId)\(Helpers.getTimeStamp())"
        ticket.id = id
        
        refTicket.document(userId).setData([id : ticketJson], options: SetOptions.merge()) { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
    func editTicket(with ticket: TicketObject, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        
        guard let ticketId = ticket.id else {
            return completionHandler("ticket id not found")
        }
        
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket to json has been failed")
        }
        
        refTicket.document(userId).updateData([ticketId : ticketJson]) { (error) in
            return completionHandler(error?.localizedDescription)
        }
        
    }
    
    func deleteTicket(withId id: String, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        
        refTicket.document(userId).updateData([id : FieldValue.delete()]) { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
}
