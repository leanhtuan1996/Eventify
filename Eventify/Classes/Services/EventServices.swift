//
//  EventServices.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss
import Haneke

class EventServices: NSObject {
    static let shared = EventServices()
    //ref User child
    
    let socket = SocketIOServices.shared
    let socketEvent = SocketIOServices.shared.socket
    
    func getEvents(completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketEvent.emit("get-events", with: [token])
        socketEvent.off("get-events")
        socketEvent.on("get-events") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                //print(json)
                
                if json[0].isEmpty {
                    return completionHandler([], nil)
                }
                
                //print(json)
                
                //try parse from json to object
                guard let events = [EventObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(events, nil)
            })
        }
    }
    
    func getMoreEvents(_ from: Int, completionHandler: @escaping(_ events: [EventObject]?, _ error: String?) -> Void ) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketEvent.emit("get-more-events", with: [from, token])
        socketEvent.off("get-more-events")
        socketEvent.on("get-more-events") { (data, ack) in
            
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
                guard let events = [EventObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(events, nil)
            })
        }
    }
    
    func loadPreviousEvents(_ completionHandler: @escaping (_ events: [EventObject]?, _ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketEvent.emit("get-previous-events", with: [token])
        socketEvent.off("get-previous-events")
        socketEvent.on("get-previous-events") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                //print(json)
                
                if json[0].isEmpty {
                    return completionHandler([], nil)
                }
                
                //print(json)
                
                //try parse from json to object
                guard let events = [EventObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(events, nil)
            })
        }
    }
    
    func loadMorePreviousEvents(_ from: Int, _ completionHandler: @escaping (_ events: [EventObject]?, _ error: String?) -> Void) {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        socketEvent.emit("get-more-previous-events", with: [from, token])
        socketEvent.off("get-more-previous-events")
        socketEvent.on("get-more-previous-events") { (data, ack) in
            
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                //print(json)
                
                if json[0].isEmpty {
                    return completionHandler([], nil)
                }
                
                //print(json)
                
                //try parse from json to object
                guard let events = [EventObject].from(jsonArray: json) else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(events, nil)
            })
        }
    }
    
    //Done
    func getEvent(withId id: String, completionHandler: @escaping (_ event: EventObject?, _ error: String?) -> Void)  {
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler(nil, "Token not found")
        }
        
        socketEvent.emit("get-event", with: [id, token])
        
        socketEvent.off("get-event")
        
        socketEvent.on("get-event") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                guard let event = EventObject(json: json[0]) else {
                    return completionHandler(nil, "Convert json to object has been failed")
                }
                
                return completionHandler(event, nil)
            })
        }
    }
    
    func getEventByIdUser(withIdUser id: String) {
        
    }
    
    
    func addEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
        if event.name == nil {
            return completionHandler("Tên sự kiện không được rỗng")
        }
        
        if event.tickets == nil || event.tickets?.count == 0 {
            return completionHandler("Vé sự kiện không được rỗng")
        }
        
        if event.timeEnd == nil || event.timeStart == nil {
            return completionHandler("Thời gian bắt đầu hoặc kết thúc không được rỗng")
        }
        
        if event.types == nil || event.types?.count == 0 {
            return completionHandler("Loại sự kiện không được rỗng")
        }
        
        if event.address == nil {
            return completionHandler("Địa chỉ sự kiện không được rỗng")
        }
        
        guard let eventJSON = event.toJSON() else {
            return completionHandler("Dữ liệu không hợp lệ")
        }
        
        guard let token = UserManager.shared.currentUser?.token else {
            return completionHandler("Token not found")
        }
        
        socketEvent.emit("new-event", with: [eventJSON, token])
        
        socketEvent.once("new-event") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler("Data is empty")
                }
                
                //try parse from json to object
                guard let success = json[0]["success"] as? Bool else {
                    return completionHandler("Path not found")
                }
                
                if success {
                    return completionHandler(nil)
                } else {
                    return completionHandler("Add event has been failed")
                }
                
            })
        }
        
    }
    
    func deleteEvents() {
    }
    
    func updateEvent(withEvent event: EventObject, completionHandler: @escaping (_ error: String?) -> Void) {
        
    }
    
    func uploadImageCover(data imgData: Data, completionHandler: @escaping (_ urlImg: String?, _ error: String?) -> Void ) {
        guard let user = UserManager.shared.currentUser, let token = user.token else {
            return completionHandler(nil, "Current user not found")
        }
        
        let imgPath = "\(user.id)\(Helpers.getTimeStampWithInt()).jpg"
        socketEvent.emit("upload-image-cover-event", with: [imgData, imgPath, token])
        
        socketEvent.once("upload-image-cover-event") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, "Data is empty")
                }
                
                //try parse from json to object
                guard let path = json[0]["path"] as? String else {
                    return completionHandler(nil, "Path not found")
                }
                
                return completionHandler(path, nil)
                
            })
        }
    }
    
    func uploadImageDescriptionEvent(data imgData: Data, completionHandler: @escaping (_ path: String?, _ downloadURL: String?, _ error: String?) -> Void ) {
        guard let user = UserManager.shared.currentUser, let token = user.token else {
            return completionHandler(nil, nil, "Current user not found")
        }
        
        let imgPath = "\(user.id)\(Helpers.getTimeStampWithInt()).jpg"
        socketEvent.emit("upload-image-description-event", with: [imgData, imgPath, token])
        
        socketEvent.once("upload-image-description-event") { (data, ack) in
            Helpers.errorHandler(with: data, completionHandler: { (json, error) in
                if let error = error {
                    return completionHandler(nil, nil, error)
                }
                
                guard let json = json, json.count > 0 else {
                    return completionHandler(nil, nil, "Data is empty")
                }
                
                //try parse from json to object
                guard let path = json[0]["path"] as? String, let downloadURL = json[0]["downloadURL"] as? String else {
                    return completionHandler(nil, nil, "Path not found")
                }
                
                return completionHandler(path, downloadURL, nil)
            })
        }
    }
}
