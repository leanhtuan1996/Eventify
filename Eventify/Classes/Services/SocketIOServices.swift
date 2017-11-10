//
//  SocketIOServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SocketIO

let baseUrl: String = "http://192.168.31.96:3000"

class SocketIOServices: NSObject {
    static let shared = SocketIOServices()
    
    //let socket = SocketIOClient(socketURL: URL(string: baseUrl)!)
    
    let socket = SocketIOClient(socketURL: URL(string: baseUrl)!, config: [SocketIOClientConfiguration.Element.reconnects(true), SocketIOClientConfiguration.Element.reconnectAttempts(30), SocketIOClientConfiguration.Element.reconnectWait(3)])
    
    
    func establishConnection() {
        print("CONNECTED")
        
        if isConnected() { return }
        
        socket.connect()
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
    
    
    func join(withNameSpace name: String) {
        
        socket.joinNamespace(name)
        
        print("Socket was joined to User namespace")
        
    }
    
    func leaveNamespace() {
        
        socket.leaveNamespace()
        
        print("Socket was leaved to User namespace")
    }
    
    
}
