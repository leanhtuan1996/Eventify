//
//  TicketServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketServices: NSObject {
    static let shared = TicketServices()
    
    let socket = SocketIOServices.shared.socket
    
    func getTickets(completionHandler: @escaping (_ tickets: [TicketObject]?, _ error: String?) -> Void ) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            print("User id not found")
            return completionHandler(nil, "User id not found")
        }
        
        socket.emit("get-tickets", with: [token])
        
        socket.off("get-tickets")
        
        socket.on("get-tickets") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                if json[0].isEmpty { return completionHandler([], nil) }
                
                //try parse from json to object
                guard let tickets = [TicketObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(tickets, nil)
                
            })
        }
        
    }
    
    func getTicket(withId id: String, completionHandler: @escaping (_ ticket: TicketObject?, _ error: String?) -> Void) {
        
    }
    
    func addTicket(with ticket: TicketObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token not found")
        }
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket object to json has been failed")
        }
        
        socket.emit("new-ticket", with: [ticketJson, token])
        
        socket.once("new-ticket") { (data, ack) in
            
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
    
    func editTicket(with ticket: TicketObject, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token not found")
        }
        
        guard let ticketJson = ticket.toJSON() else {
            return completionHandler("Convert ticket object to json has been failed")
        }
        
        socket.emit("edit-ticket", with: [ticketJson, token])
        
        socket.once("edit-ticket") { (data, ack) in
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
        
        socket.emit("delete-ticket", with: [id, token])
        
        socket.once("delete-ticket") { (data, ack) in
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
    
    func getTickets(withEvent id: String,_ completionHandler: @escaping (_ idEvent: String?, _ tickets: [TicketObject]?, _ error: String?) -> Void){
        guard let token = UserManager.shared.currentUser?.token else {
            print("User id not found")
            return completionHandler(nil, nil, "User id not found")
        }
        
        socket.emit("get-detail-tickets", with: [id, token])
        
        socket.off("get-detail-tickets")
        
        socket.on("get-detail-tickets") { (data, ack) in
            
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                
                if let error = error {
                    return completionHandler(nil, nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, nil, "Data is empty")
                }
                
                
                if json[0].isEmpty { return completionHandler(nil, [], nil) }
                
                guard let ticketsJson = json[0]["tickets"] as? [JSON], let idEvent = json[0]["event"] as? String else {
                    return completionHandler(nil, nil, "Data is empty")
                }
                
                //try parse from json to object
                guard let tickets = [TicketObject].from(jsonArray: ticketsJson) else {
                    return completionHandler(nil, nil, "Convert json to object has been failed")
                }
                
                return completionHandler(idEvent, tickets, nil)
                
            })
        }

    }
}
