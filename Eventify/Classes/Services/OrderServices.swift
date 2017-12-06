//
//  OrderServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class OrderServices: NSObject {
    static let shared = OrderServices()
    let socket = SocketIOServices.shared.socket
    
    var currentOrder: OrderObject?
    
    func beginOrder(order: OrderObject, completionHandler: @escaping (_ error: String? ) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token is required!")
        }
        
        guard let json = order.toJSON() else {
            return completionHandler("Convert object to json has been failed");
        }
        
        socket.emit("begin-order", with: [json, token])
        
        socket.once("begin-order") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                guard let order = OrderObject(json: json[0]) else {
                    return completionHandler("Convert json to object has been failed")
                }
                
                self.currentOrder = order
                
                return completionHandler(nil)
            })
        }
    }
    
    func newOrder(withName fullName: String, andPhone phone: String, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token is required!")
        }
        
        self.currentOrder?.fullName = fullName
        self.currentOrder?.phoneNumber = phone
        
        guard let json = self.currentOrder?.toJSON() else {
            return completionHandler("Convert object to json has been failed");
        }
        
        socket.emit("order", with: [json, token])
        
        socket.once("order") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                self.currentOrder = nil
                
                return completionHandler(nil)
            })
        }
    }
    
    func getOrders(_ completionHandler: ((_ error: String?) -> Void)? = nil) {
        guard let token = UserManager.shared.currentUser?.token else {
            completionHandler?("Token is required!")
            return
        }
        
        socket.emit("get-orders", with: [token])
        
        socket.off("get-orders")
        
        socket.on("get-orders") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    completionHandler?(error)
                    return
                }
                
                guard let json = json, json.count > 0 else {
                    completionHandler?("Data is empty")
                    return
                }
                
                //print(json)
                
                if json[0].isEmpty {
                    completionHandler?(nil)
                    return
                }
                
                //try parse from json to object
                guard let orders = [OrderObject].from(jsonArray: json) else {
                    completionHandler?("Path not found")
                    return
                }
                
                UserManager.shared.currentUser?.orders = orders
                
                completionHandler?(nil)
            })
        }
    }
    
    func getOrder(byId id: String, completionHandler: @escaping (_ order: OrderObject?, _ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token is required!")
        }
        
        socket.emit("get-order", with: [id, token])
        
        socket.off("get-order")
        
        socket.on("get-order") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                guard let order = OrderObject(json: json[0]) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(order, nil)
            })
        }
    }
    
    func cancelOrder(completionHandler: @escaping (_ error: String? ) -> Void ) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Missing token")
        }
        
        guard let id = self.currentOrder?.id else {
            return completionHandler("Missing order")
        }
        
        socket.emit("cancel-order", with: [id, token]);
        
        socket.once("cancel-order") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                return completionHandler(nil)
            })
        }
    }
}
