//
//  ActionTicketDelegate.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

protocol ActionTicketDelegate {
    func addToCalendar(withName name: String, start dateStart: Int, end dateEnd: Int, andLocation location: AddressObject) -> Void
    func viewMap(address: AddressObject) -> Void
    func viewEvent(withId id: String) -> Void
}
