//
//  InforDialogVC.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 1/3/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class InforDialogVC: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCodeNumber: UILabel!
    @IBOutlet weak var lblTicketType: UILabel!
    
    var info: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.lblStatus.text = ((self.info?["STATUS"] as? Bool) ?? false) == true ? "Hợp lệ" : "Không hợp lệ"
        self.lblFullName.text = (self.info?["NAME"] as? String) ?? "Không rõ"
        self.lblPhone.text = (self.info?["PHONE"] as? Int)?.toString() ?? "Không rõ"
        self.lblCodeNumber.text = (self.info?["CODE_NUMBER"] as? String) ?? "Không rõ"
        self.lblTicketType.text = (self.info?["TICKET_TYPE"] as? String) ?? "Không rõ"
        
        self.showAnimate()
    }
    
    func showAnimate()
    {
        self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.infoView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.infoView.alpha = 1.0
            self.infoView.transform = CGAffineTransform.identity
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.infoView.alpha = 0.0
        }, completion: {(finished : Bool) in
            if finished
            {
                self.info = nil
                self.parent?.didMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    @IBAction func btnNextClicked(_ sender: Any) {
        self.removeAnimate()
    }
}
