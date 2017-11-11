//
//  TicketServicesTest.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import Gloss

class TicketServicesTest: NSObject {
    static let shared = TicketServicesTest()
    
    let socket = SocketIOServices.shared
    let socketTicket = SocketIOServices.shared.socket
    
    func getTickets(completionHandler: @escaping (_ tickets: [TicketObjectTest]?, _ error: String?) -> Void ) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            print("User id not found")
            return completionHandler(nil, "User id not found")
        }
        
        socketTicket.emit("get-tickets", with: [token])
        
        socketTicket.off("get-tickets")
        
        socketTicket.on("get-tickets") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                
                if let error = error {
                    return completionHandler(nil, error)
                }
                
//                //try parse from json to object
//                guard let json = json as? [JSON] else {
//                    return completionHandler(nil, "Convert json to array has been failed")
//                }
//                
//                if let tickets = [TicketObjectTest].from(jsonArray: json) {
//                    print(tickets[0].id)
//                    return completionHandler(tickets, nil)
//                } else {
//                    return completionHandler(nil, "Convert json to object has been failed")
//                }
                
            })
        }
        
    }
    
    func getTicket(withId id: String, completionHandler: @escaping (_ ticket: TicketObject?, _ error: String?) -> Void) {
        
    }
    
    func addTicket(with ticket: TicketObjectTest, completionHandler: @escaping (_ ticket: TicketObjectTest?, _ error: String?) -> Void) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler(nil, "Convert ticket object to json has been failed")
        }
        
        socketTicket.emit("new-ticket", with: [ticketJson, token])
        
        socketTicket.once("new-ticket") { (data, ack) in
          
            //check data is nil or empty
            if data.isEmpty || data.count == 0 {
                return completionHandler(nil, "Data not found")
            }
            
            //get the first value in data and try parse to json
            guard let json = data.first as? JSON else {
                return completionHandler(nil, "Convert data to json has been failed")
            }
            
            //errors handler
            if let errors = json["errors"] as? [String] {
                if errors.count != 0 {
                    return completionHandler(nil, errors[0])
                } else {
                    return completionHandler(nil, "Error not found")
                }
            }
            
            //try parse from json to object
            guard let ticket = TicketObjectTest(json: json) else {
                return completionHandler(nil, "Convert json to object has been failed")
            }
            
            return completionHandler(ticket, nil)
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
        
        
        guard let token = UserManager.shared.currentUser?.token else {
            print("User id not found")
            return completionHandler("User id not found")
        }
        
        socketTicket.emit("delete-ticket", with: [id, token])
        
        socketTicket.off("delete-ticket")
        
        socketTicket.on("delete-ticket") { (data, ack) in
            print(data)
        }
    }
    
    
    
}

