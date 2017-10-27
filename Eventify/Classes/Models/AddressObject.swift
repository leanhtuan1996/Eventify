//
//  AddressObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/26/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//


import UIKit
import Gloss

class AddressObject: NSObject, Glossy {
    var placeId: String
    var latitude: Double?
    var longtutude: Double?
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
        
        //for get place with google maps
        if let geometry: JSON = "geometry" <~~ json {
            print(geometry)
            if let location = geometry["location"] as? JSON {
                self.latitude = location["lat"] as? Double
                self.longtutude = location["lng"] as? Double
            }
        }
        
        if let lat: Double = "lat" <~~ json {
            self.latitude = lat
        }
        
        if let lng: Double = "lng" <~~ json {
            self.longtutude = lng
        }
        
        self.address = "formatted_address" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "place_id" ~~> self.placeId,
            "lat" ~~> self.latitude,
            "lng" ~~> self.longtutude,
            "formatted_address" ~~> self.address
            ])
    }
}
