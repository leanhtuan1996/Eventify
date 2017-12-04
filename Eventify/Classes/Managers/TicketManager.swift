//
//  TicketManager.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketManager: NSObject {
    static let shared = TicketManager()
    let userDefault = UserDefaults.standard
    
    func getTickets() -> [TicketObject] {
        
        print("GET TICKETS")
        if let data = userDefault.object(forKey: "tickets") as? Data {
            if let tickets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TicketObject] {
                //currentTickets = tickets
                return tickets
            }
        }
        return []
    }
    
    func getTicket(byId id: String) -> TicketObject? {
        print("GET TICKET")
        let currentTickets = getTickets()
        if let index = currentTickets.index(where: { (ticket) -> Bool in
            return id == ticket.id
        }) {
            return currentTickets[index]
        }
        return nil
    }
    
    func deleteTickets() {
        print("DELETE TICKETS")
        if userDefault.object(forKey: "tickets") != nil {
            userDefault.removeObject(forKey: "tickets")
        }
    }
    
    func deleteTicket(byId id: String) {
        var currentTickets = getTickets()
        if let index = currentTickets.index(where: { (ticket) -> Bool in
            return id == ticket.id
        }) {
            currentTickets.remove(at: index)
            //deleteTickets()
            addTickets(with: currentTickets)
        }
    }
    
    func addTicket(with ticket: TicketObject) {
        var currentTickets = getTickets()
        if currentTickets.contains(where: { (t) -> Bool in
            return t.id == ticket.id
        }) {
            editTicket(with: ticket)
        } else {
            if let idUser = UserManager.shared.currentUser?.id {
                ticket.id = "\(idUser)\(Helpers.getTimeStamp())"
            }
            currentTickets.append(ticket)
            
            //begin add to userdefault
            let ticketsData = NSKeyedArchiver.archivedData(withRootObject: currentTickets)
            userDefault.set(ticketsData, forKey: "tickets")
            userDefault.synchronize()

        }
    }
    
    func addTickets(with tickets: [TicketObject]) {
        print("ADD TICKETS")
        //begin add to userdefault
        let ticketsData = NSKeyedArchiver.archivedData(withRootObject: tickets)
        userDefault.set(ticketsData, forKey: "tickets")
        userDefault.synchronize()
    }
    
    func editTicket(with ticket: TicketObject) {
        var currentTickets = getTickets()
        print("EDIT TICKET")
        if let index = currentTickets.index(where: { (t) -> Bool in
            return ticket.id == t.id
        }) {
            currentTickets[index] = ticket
            addTickets(with: currentTickets)
        }
    }

}
