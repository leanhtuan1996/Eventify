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
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblNameOfType: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
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
        
        
        btnShare.layer.cornerRadius = 20
        btnShare.layer.borderWidth = 0.5
        btnShare.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        btnLike.layer.cornerRadius = 20
        btnLike.layer.borderWidth = 0.5
        btnLike.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        //btnLabel.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
