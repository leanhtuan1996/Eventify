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
    var longitude: Double?
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
            if let location = geometry["location"] as? JSON {
                self.latitude = location["lat"] as? Double
                self.longitude = location["lng"] as? Double
            }
        }
        
        if let address: String = "formatted_address" <~~ json {
            self.address = address
        }
        
        //for api
        if let lat: Double = "latitude" <~~ json {
            self.latitude = lat
        }
        
        if let lng: Double = "longitude" <~~ json {
            self.longitude = lng
        }
        
        if let address: String = "address" <~~ json {
            self.address = address
        }
        
        
        
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "place_id" ~~> self.placeId,
            "latitude" ~~> self.latitude,
            "longitude" ~~> self.longitude,
            "address" ~~> self.address
            ])
    }
}
