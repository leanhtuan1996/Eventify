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
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                if json[0].isEmpty { return completionHandler([], nil) }
                
                //try parse from json to object
                guard let tickets = [TicketObjectTest].from(jsonArray: json) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(tickets, nil)
                
            })
        }
        
    }
    
    func getTicket(withId id: String, completionHandler: @escaping (_ ticket: TicketObject?, _ error: String?) -> Void) {
        
    }
    
    func addTicket(with ticket: TicketObjectTest, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token not found")
        }
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket object to json has been failed")
        }
        
        socketTicket.emit("new-ticket", with: [ticketJson, token])
        
        socketTicket.once("new-ticket") { (data, ack) in
          
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                return completionHandler(nil)
            })
       }
    }
    
    func editTicket(with ticket: TicketObjectTest, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token not found")
        }
        
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket object to json has been failed")
        }
       
        socketTicket.emit("edit-ticket", with: [ticketJson, token])
        
        socketTicket.on("edit-ticket") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                return completionHandler(nil)
            })
        }
    }
    
    func deleteTicket(withId id: String, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            print("User id not found")
            return completionHandler("User id not found")
        }
        
        socketTicket.emit("delete-ticket", with: [id, token])
        
        socketTicket.once("delete-ticket") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                return completionHandler(nil)
            })
        }
    }
    
    
    
}

