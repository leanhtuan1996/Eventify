//
//  EventProtocols.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/26/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

protocol EventDelegate {
    func selectedType(with type: TypeObject) -> Void
    func selectedAddress(with address: AddressObject) -> Void
    func discriptionEditor(with text: String, html: String) -> Void
}
