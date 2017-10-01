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
    
    var currentTickets: [TicketObject] = []
    
    func getTickets() -> [TicketObject]{
        if let data = userDefault.object(forKey: "tickets") as? Data {
            if let tickets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TicketObject] {
                currentTickets = tickets
                return currentTickets
            }
        }
        return currentTickets
    }
    
    func getTicket(byId id: Int) -> TicketObject? {
        currentTickets = getTickets()
        if let index = currentTickets.index(where: { (ticket) -> Bool in
            return id == ticket.id
        }) {
            return currentTickets[index]
        } else {
            return nil
        }
        
    }
    
    func deleteTickets() {
        if userDefault.object(forKey: "tickets") != nil {
            userDefault.removeObject(forKey: "tickets")
        }
    }
    
    func deleteTicket(byId id: Int) {
        currentTickets = getTickets()
        if let index = currentTickets.index(where: { (ticket) -> Bool in
            return id == ticket.id
        }) {
            currentTickets.remove(at: index)
            deleteTickets()
            addTickets(with: currentTickets)
        }
    }
    
    func addTicket(with ticket: TicketObject) {
        
        //if let have data in userdefault
        if let data = userDefault.object(forKey: "tickets") as? Data {
            if let tickets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TicketObject] {
                //print(orders)
                for ticket in tickets {
                    currentTickets.append(ticket)
                }
            }
        }
        
        ticket.id = currentTickets.count
        currentTickets.append(ticket)
        
        //begin add to userdefault
        let ticketsData = NSKeyedArchiver.archivedData(withRootObject: currentTickets)
        userDefault.set(ticketsData, forKey: "tickets")
        userDefault.synchronize()
        
    }
    
    func addTickets(with tickets: [TicketObject]) {
        
        //begin add to userdefault
        let ticketsData = NSKeyedArchiver.archivedData(withRootObject: tickets)
        userDefault.set(ticketsData, forKey: "tickets")
        userDefault.synchronize()
    }
    
    func editTicket(with ticket: TicketObject) {
        if let index = currentTickets.index(where: { (t) -> Bool in
            return ticket.id == t.id
        }) {
            currentTickets[index] = ticket
            deleteTickets()
            addTickets(with: currentTickets)
        }
    }

}
