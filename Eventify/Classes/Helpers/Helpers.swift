//
//  Helpers.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

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
        return String(date.timeIntervalSince1970)
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
}
