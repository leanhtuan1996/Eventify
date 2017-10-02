//
//  EventsCell.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var btnLabel: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    var event: EventObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowRadius = 4
        self.cellView.layer.shadowOpacity = 0.25
        self.cellView.layer.masksToBounds = false;
        self.cellView.clipsToBounds = false;
        
        //btnLabel.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
