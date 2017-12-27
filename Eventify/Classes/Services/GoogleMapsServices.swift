//
//  GoogleMapsServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/26/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class GoogleMapsServices: NSObject {
    static let shared = GoogleMapsServices()
    let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apiKey = "AIzaSyD8T0J9zFSbM_wC3kl46FgBT68Ev9AkLnw"
    
    func getAddressForLatLng(latitude: String, longitude: String, completionHandler: @escaping(_ address: AddressObject?, _ error: String?) -> Void) {
        let geoRequest = "\(baseURL)latlng=\(latitude),\(longitude)&key=\(apiKey)"
        Alamofire.request(geoRequest)
            .validate()
            .responseJSON { (response) in
                guard let json = response.value as? JSON, let results = json["results"] as? [JSON], let status = json["status"] as? String else {
                    return completionHandler(nil, "Parse response to json failed")
                }
                
                if status != "OK" {
                    return completionHandler(nil, "Get address incompleted")
                }
                
                guard let firstResult = results.first else {
                    return completionHandler(nil, "Result not found")
                }
                
                if let address = AddressObject(json: firstResult) {
                    
                    return completionHandler(address, nil)
                } else {
                    return completionHandler(nil, "Parse json to object has been failed")
                }
        }
    }
}
