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
    
    func getAddressForLatLng(latitude: String, longitude: String, completionHandler: @escaping(_ address: AddressObjectTest?, _ error: String?) -> Void) {
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
                //print(firstResult)
                if let address = AddressObjectTest(json: firstResult) {
                    return completionHandler(address, nil)
                } else {
                    return completionHandler(nil, "Parse json to object has been failed")
                }
        }
        
//        let url = URL(string: "latlng=\(latitude),\(longitude)&key=AIzaSyD8T0J9zFSbM_wC3kl46FgBT68Ev9AkLnw")
//        let data = NSData(contentsOf: url!)
//        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//        if let result = json["results"] as? NSArray {
//            //            if let address = result[0]["address_components"] as? NSArray {
//            //                let number = address[0]["short_name"] as! String
//            //                let street = address[1]["short_name"] as! String
//            //                let city = address[2]["short_name"] as! String
//            //                let state = address[4]["short_name"] as! String
//            //                let zip = address[6]["short_name"] as! String
//            //                print("\n\(number) \(street), \(city), \(state) \(zip) \(address)")
//            //            }
//            print(result)
//        }
    }
}
