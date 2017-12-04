//
//  TypeObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TypeObject: NSObject, Glossy {
    var id: String
    var name: String?
    
    override init() {
        self.id = ""
        super.init()
    }
    
    required init?(json: JSON) {
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        self.id = id
        self.name = "name" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify(
            ["_id" ~~> self.id,
             "name" ~~> self.name
            ])
    }
    
}
