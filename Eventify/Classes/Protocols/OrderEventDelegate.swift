//
//  OrderEventDelegate.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

protocol OrderEventDelegate {
    func chooseTicket(with ticket: TicketObjectTest) -> Void
    func unChooseTicket(with ticket: TicketObjectTest) -> Void
}
