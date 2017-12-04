//
//  TypeEventService.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TypeEventServices: NSObject {
    static let shared = TypeEventServices()
    
    let socketType = SocketIOServices.shared.socket
    
    func getTypesEvent(completionHandler: @escaping (_ types: [TypeObject]?, _ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketType.emit("get-types", with: [token])
        socketType.once("get-types") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                if json[0].isEmpty {
                    return completionHandler([], nil)
                }
                
                //try parse from json to object
                guard let types = [TypeObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(types, nil)
            })
        }
    }
}
