//
//  NewEventVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/30/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class NewEventVC: UIViewController {

    @IBOutlet weak var imgPicker: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblNameEvent: UITextField!
    @IBOutlet weak var lblByOrganizer: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var txtDetailAddress: UITextField!
    @IBOutlet weak var lblEventType: UILabel!
    @IBOutlet weak var lblNumberTickets: UILabel!
    
    override func viewDidLoad(
        ) {
        super.viewDidLoad()
        let tapForLblNumberTickets = UITapGestureRecognizer(target: self, action: #selector(self.showTicketsManager))
        lblNumberTickets.isUserInteractionEnabled = true
        lblNumberTickets.addGestureRecognizer(tapForLblNumberTickets)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        if let user = UserServices.shared.currentUser {
            lblByOrganizer.text = "Bởi " + (user.fullName ?? "")
        }
        
        lblNumberTickets.text = TicketManager.shared.getTickets().count.toString() + " loại vé"
    }
    

    func showTicketsManager() {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "TicketsManagerVC") as? TicketsManagerVC {
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
    @IBAction func btnDoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnMoreClicked(_ sender: Any) {
    }

}
