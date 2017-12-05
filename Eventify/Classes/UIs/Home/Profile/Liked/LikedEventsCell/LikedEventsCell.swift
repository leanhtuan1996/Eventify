//
//  LikedEventsCell.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/5/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class LikedEventsCell: UITableViewCell {

    var event: EventObject?
    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblNameEvent: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.imgCover.layer.cornerRadius = 5

        // Configure the view for the selected state
    }
    
    @IBAction func btnUnlikeClicked(_ sender: Any) {
        guard let id = event?.id else {
            return
        }
        
        UserServices.shared.UnlikeEvent(with: id)
        
    }
}
