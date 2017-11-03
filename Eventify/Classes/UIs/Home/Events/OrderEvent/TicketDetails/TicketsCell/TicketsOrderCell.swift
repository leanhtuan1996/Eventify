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
    }
    
    @IBAction func btnMinusClicked(_ sender: Any) {
    }
}
