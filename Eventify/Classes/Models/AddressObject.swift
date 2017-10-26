//
//  AddressObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/26/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//


import UIKit
import Gloss

class AddressObject: NSObject, Decodable {
    var placeId: String
    var latitude: String?
    var longtutude: String?
    var address: String?
    
    override init() {
        self.placeId = ""
        super.init()
    }
    
    required init?(json: JSON) {
        guard let placeId: String = "place_id" <~~ json else {
            return nil
        }
        self.placeId = placeId
        
        if let geometry: JSON = "geometry" <~~ json {
            if let location = geometry["location"] as? JSON {
                self.latitude = location["lat"] as? String
                self.longtutude = location["lng"] as? String
            }
        }
        
        self.address = "formatted_address" <~~ json
    }
}
