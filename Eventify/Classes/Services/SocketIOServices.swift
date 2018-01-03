//
//  SocketIOServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SocketIO

//let baseUrl: String = "https://www.estenials.me"
//let baseUrl: String = "http://0.0.0.0:8080"
let baseUrl: String = "http://192.168.31.96:8080"

class SocketIOServices: NSObject {
    static let shared = SocketIOServices()
    
    let socket = SocketIOClient(socketURL: URL(string: baseUrl)!, config: [SocketIOClientConfiguration.Element.reconnects(true), SocketIOClientConfiguration.Element.reconnectAttempts(120), SocketIOClientConfiguration.Element.reconnectWait(3), SocketIOClientConfiguration.Element.compress, SocketIOClientConfiguration.Element.nsp("/")])
    
    func establishConnection(completionHandler: ((_ error: String?) -> Void)? = nil) {
        
        if isConnected() { completionHandler?(nil); return }
        
        socket.connect(timeoutAfter: 10.0) { 
            completionHandler?("Connect to server has been failed!")
        }
        
        socket.once("joined") { (data, ack) in
            completionHandler?(nil)
            return
        }
    }
    
    func closeConnection() {
        
        if !isConnected() { return }
        
        socket.disconnect()
    }
    
    func isConnected() -> Bool {
        switch socket.status {
        case .connected:
            return true
        default:
            return false
        }
    }
    
    func isNotConnected() -> Bool {
        switch socket.status {
        case .notConnected:
            return true
        default:
            return false
        }
    }
    
    func isDisconnected() -> Bool {
        switch socket.status {
        case .disconnected:
            return true
        default :
            return false
        }
    }
    
    func reConnect() {
        if !isConnected() {
            socket.reconnect()
        }
    }
}
