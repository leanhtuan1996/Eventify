//
//  Helpers.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import EventKit
import Gloss

class Helpers: NSObject {
    static func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    static func convertObjectToJson(_ object: Any) -> [String: Any]? {
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            //if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            //print(JSONString)
            //}
            
            return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    static func emptyMessage(_ activityIndicatorView:UIActivityIndicatorView, tableView:UITableView) {
        
        //let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        //tableView.view.addSubview(activityIndicatorView)
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.frame = tableView.frame
        activityIndicatorView.center = tableView.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.sizeToFit()
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //Handled Error
    static func handleError(_ response: HTTPURLResponse?, error: NSError) -> String {
        
        guard let res = response else {
            return "Error not found"
        }
        
        if error.isNoInternetConnectionError() {
            print("Internet Connection Error")
            return "Internet Connection Error"
        } else if error.isRequestTimeOutError() {
            print("Request TimeOut")
            return "Request TimeOut"
        } else if res.isServerNotFound() {
            print("Server not found")
            return "Server not found"
        } else if res.isInternalError() {
            print("Internal Error")
            return "Internal Error"
        }
        return "Error Not Found"
    }
    
    static func getTimeStamp() -> String {
        let date = Date()
        return String(date.timeIntervalSince1970.toInt())
    }
    
    static func getTimeStampWithInt() -> Int {
        let date = Date()
        return date.timeIntervalSince1970.toInt()
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    static func downloadedFrom(url: URL, completionHandler: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        //contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return completionHandler(nil, "ERROR") }
            
            return completionHandler(image, nil)
            
            }.resume()
    }
    static func downloadedFrom(link: String, completionHandler: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url) { (image, error) in
            return completionHandler(image, error)
        }
    }
    
    static func addBlurEffect(toView view:UIView?) {
        // Add blur view
        guard let view = view else { return }
        
        
        //This will let visualEffectView to work perfectly
        if let navBar = view as? UINavigationBar{
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
        }
        
        
        var bounds = view.bounds
        bounds.offsetBy(dx: 0.0, dy: 0.0)
        bounds.size.height = bounds.height
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(visualEffectView, at: 0)
        
    }
    
    static func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, location: AddressObject,  completion: ((_ error: String?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if !granted {
                completion?("Ứng dụng chưa được cấp phép sử dụng lịch của bạn. Vui lòng đi đến Cài Đặt -> Quyền riêng tư -> Lịch để cấp phép và thử lại")
                return
            }
            
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                
                if let address = location.address, let latitude = location.latitude, let longtitude = location.longitude {
                    let location = EKStructuredLocation(title: address)
                    location.geoLocation = CLLocation(latitude: latitude, longitude: longtitude)
                    event.structuredLocation = location
                }
                
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.isAllDay = false
                event.location = location.address ?? "Vị trí không xác định"
                event.addAlarm(EKAlarm(absoluteDate: startDate))
                
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e {
                    completion?(e.localizedDescription)
                    return
                }
                completion?(nil)
            } else {
                completion?(error?.localizedDescription)
            }
        })
    }
    
    static func errorHandler(with data: [Any], completionHandler: @escaping (_ json: [JSON]?, _ error: String?) -> Void ) {
        //check data is nil or empty
        
        if data.isEmpty || data.count == 0 {
            return completionHandler(nil, "Data not found")
        }
        
        //get the first value in data and try parse to json
        guard let json = data.first as? [JSON] else {
            return completionHandler(nil, "Convert data to json has been failed")
        }
        
        if json.count == 0 { return completionHandler(nil, "Data not found") }
        
        //errors handler
        if let error = json[0]["error"] as? String {
            return completionHandler(nil, error)
        }
        
        return completionHandler(json, nil)
    }
    
    static func handlerPrice(for tickets: [TicketObject]) -> (String, String) {
        
        if tickets.count > 0 {
            
            var min = tickets[0].price ?? 0
            var max = tickets[0].price ?? 0
            
            //Get all price in array
            for ticket in tickets {
                if let price = ticket.price {
                    min = price < min ? price : min
                    max = price > max ? price : max
                } else {
                    min = 0
                }
            }
            
            return (min.toString(), max.toString())
            
        }
        
        return ("0", "0")
    }
    
    static func handlerTypes(for types: [TypeObject]) -> String {
        
        var string = ""
        
        var index = 0
        for type in types {
            if index != types.count - 1 {
                string += (type.name ?? "") + ", "
            } else {
                string += (type.name ?? "")
            }
            index += 1
        }
        
        
        return string
    }

}
