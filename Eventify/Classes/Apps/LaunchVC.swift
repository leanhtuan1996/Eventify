//
//  LaunchVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TicketManager.shared.deleteTickets()
        
        //EventServices.shared.deleteEvents()
        
        //UserServices.shared.deleteUsers()
        
        //UserServices.shared.signOut()
       
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            //Listen
            UserServicesTest.shared.isLoggedIn(completionHandler: { (error) in
                
                print("ISLOGGEDIN")
                if let _ = error {
                    appDelegate.showSignInView()
                    
                    
                }
                else {
                    appDelegate.showMainView()
                }
            })
        }
    }
}
