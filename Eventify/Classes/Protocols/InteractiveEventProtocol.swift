//
//  SharingProtocol.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/27/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

protocol InteractiveEventProtocol {
    func sharingEvent(with content: String) -> Void
    func likeEvent(with event: EventObject) -> Void
    func unLikeEvent(with event: EventObject) -> Void
}
