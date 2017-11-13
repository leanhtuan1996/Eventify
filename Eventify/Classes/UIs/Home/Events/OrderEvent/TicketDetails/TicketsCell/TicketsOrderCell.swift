//
//  TicketsOrderCell.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/3/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketsOrderCell: UITableViewCell {
    
    @IBOutlet weak var imgInfoTicket: UIImageView!
    @IBOutlet weak var lblNameTicket: UILabel!
    @IBOutlet weak var lblTicketType: UILabel!
    @IBOutlet weak var lblTicketAvailable: UILabel!
    @IBOutlet weak var viewPickerTicket: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    var delegate: OrderEventDelegate?
    var ticket: TicketObjectTest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewPickerTicket.layer.cornerRadius = 5
        viewPickerTicket.layer.borderColor = UIColor.darkGray.cgColor
        viewPickerTicket.layer.borderWidth = 1
        
        lblQuantity.layer.borderWidth = 1
        lblQuantity.layer.borderColor = UIColor.darkGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPlusClicked(_ sender: Any) {
        guard let quantityString = self.lblQuantity.text, let quantity = quantityString.toInt(), let quantityTicket = self.ticket?.quantitiesToSell else {
            return
        }
        
        if quantity == self.ticket?.maxQuantitiesToOrder { return }
        
        if quantity >= quantityTicket { return }
        
        self.lblQuantity.text = (quantity + 1).toString()
        
        if let ticket = self.ticket {
            self.delegate?.chooseTicket(with: ticket)
        }
    }
    
    @IBAction func btnMinusClicked(_ sender: Any) {
        guard let quantityString = self.lblQuantity.text, let quantity = quantityString.toInt() else {
            return
        }
        
        if quantity == 0 { return }
        
        self.lblQuantity.text = (quantity - 1).toString()
        
        if let ticket = self.ticket {
            self.delegate?.unChooseTicket(with: ticket)
        }
    }
}
