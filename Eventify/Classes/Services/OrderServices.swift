//
//  OrderServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Firebase
import Gloss

let refOrder = Firestore.firestore().collection("Orders")

class OrderServices: NSObject {
    static let shared = OrderServices()
    
    
    func newOrder(order: OrderTicketObject, completionHandler: @escaping (_ error: String?) -> Void) {
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler("User id not found")
        }
        
        guard let orderJson = order.toJSON() else {
            return completionHandler("Convert to json has been failed")
        }
        
        guard let orderId = order.id else {
            return completionHandler("Id order not found")
        }
        
        refOrder.document(userId).setData([orderId : orderJson], options: SetOptions.merge()) { (error) in
            return completionHandler(error?.localizedDescription)
        }
    }
    
    func getOrders(completionHandler: @escaping (_ orders: [OrderTicketObject]?, _ error: String?) -> Void) {
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler(nil, "User id not found")
        }
        
        refOrder.document(userId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                return completionHandler(nil, error.localizedDescription)
            }
            
            guard let snapshotDoc = snapshot, snapshotDoc.exists else {
                return completionHandler(nil, "Snapshot not found")
            }
            
            var orders: [OrderTicketObject] = []
            
            snapshotDoc.data().forEach({ (key, value) in
                
                //print(ticket)
                
                guard let orderJson = value as? JSON else {
                    return completionHandler(nil, "Convert value to json have been failed")
                }
                
                if let order = OrderTicketObject(json: orderJson) {
                    orders.append(order)
                }
            })
            
            completionHandler(orders, nil)
        }
    }
    
    func getOrder(byId id: String, completionHandler: @escaping (_ order: OrderTicketObject?, _ error: String?) -> Void) {
        guard let userId = UserServices.shared.currentUser?.id else {
            return completionHandler(nil, "User id not found")
        }
        
        
    }
}
