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
    
    var namespaceJoined: [String] = []
    
    //let socket = SocketIOClient(socketURL: URL(string: baseUrl)!)
    
    let socket = SocketIOClient(socketURL: URL(string: baseUrl)!, config: [SocketIOClientConfiguration.Element.reconnects(true), SocketIOClientConfiguration.Element.reconnectAttempts(30), SocketIOClientConfiguration.Element.reconnectWait(3)])
    
    
    func establishConnection(completionHandler: (() -> Void)? = nil) {
        print("CONNECTED")
        
        if isConnected() { completionHandler?(); return }
        
        socket.connect()
        
        socket.on("joined") { (data, ack) in
            completionHandler?()
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
    
    
    func join(withNameSpace name: String) {
        
        if self.checkExistNamespace(with: name) {
            print("exist")
            return
        }
        socket.joinNamespace(name)
        self.namespaceJoined.append(name)
        print("Socket was joined to \(name) namespace")
        
    }
    
    func leaveNamespace() {
        
        socket.leaveNamespace()
        
        print("Socket was leaved to namespace")
    }
    
    
    func checkExistNamespace(with name: String) -> Bool {
        if self.namespaceJoined.contains(where: { (namespace) -> Bool in
            return name == namespace
        }) {
            return true
        }
        return false
    }
    
}
