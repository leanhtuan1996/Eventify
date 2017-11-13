//
//  TicketCells.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketCells: UITableViewCell {

    var ticketObject = TicketObjectTest()
    @IBOutlet weak var lblNameTicket: UILabel!
    @IBOutlet weak var lblQuantitySold: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lblNameTicket.text = ticketObject.name
//        lblQuantitySold.text = ticketObject.quantity?.toString()
//        lblPrice.text = ticketObject.price?.toString()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
