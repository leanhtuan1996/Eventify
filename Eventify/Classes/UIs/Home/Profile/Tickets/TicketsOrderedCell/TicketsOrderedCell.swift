//
//  TicketsOrderedCell.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketsOrderedCell: UITableViewCell {

    @IBOutlet weak var lblTotalTickets: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblNameEvent: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
