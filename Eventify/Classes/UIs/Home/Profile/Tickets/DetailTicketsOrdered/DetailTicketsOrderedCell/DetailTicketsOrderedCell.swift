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
    
    var timeStart: Int?
    var timeEnd: Int?
    var address: AddressObject?
    var delegate: ActionTicketDelegate?
    var idEvent: String?
    
    var vc: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.viewCountTicket.layer.cornerRadius = 15        
        self.viewTicket.layer.cornerRadius = 15
    }
    
    
    @IBAction func btnAddToCalendar(_ sender: Any) {
        guard let name = lblNameOfEvent.text, let dayStart = timeStart, let dateEnd = timeEnd, let location = address else {
            return
        }
        
        self.delegate?.addToCalendar(withName: name, start: dayStart, end: dateEnd, andLocation: location)
    }

    @IBAction func btnOpenMaps(_ sender: Any) {
        guard let address = self.address else {
            return
        }
        
        self.delegate?.viewMap(address: address)
        
    }
    @IBAction func btnViewDetailEventClicked(_ sender: Any) {
        guard let id = self.idEvent else {
            return
        }
        
        self.delegate?.viewEvent(withId: id)
    }
}
