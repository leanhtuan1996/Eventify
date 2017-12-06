//
//  DetailTicketsOrderedCell.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailTicketsOrderedCell: UICollectionViewCell {

    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var viewTicket: UIView!
    @IBOutlet weak var viewCountTicket: UIView!
    @IBOutlet weak var lblNumberOfTickets: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblNameOfEvent: UILabel!
    @IBOutlet weak var lblNameOfTicket: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblIdOfOrder: UILabel!
    @IBOutlet weak var lblNameOfCreated: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.viewCountTicket.layer.cornerRadius = 15        
        self.viewTicket.layer.cornerRadius = 15
    }
    
    
    @IBAction func btnAddToCalendar(_ sender: Any) {
        
    }

    @IBAction func btnOpenMaps(_ sender: Any) {
        
    }
    @IBAction func btnViewDetailEventClicked(_ sender: Any) {
        
    }
}
