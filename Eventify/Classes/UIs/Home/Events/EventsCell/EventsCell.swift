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
    
    var event: EventObjectTest?
    var delegate: InteractiveEventProtocol?
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUi()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpUi() {
        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowRadius = 4
        self.cellView.layer.shadowOpacity = 0.25
        self.cellView.layer.masksToBounds = false;
        self.cellView.clipsToBounds = false;
        
        btnShare.layer.cornerRadius = 22.5
        btnShare.layer.borderWidth = 0.5
        btnShare.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        btnLike.layer.cornerRadius = 22.5
        btnLike.layer.borderWidth = 0.5
        btnLike.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
    }
    
    
    @IBAction func btnShare(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        let contentToSharing = "Hãy đến với \(event.address?.address ?? "") vào lúc \(event.timeStart?.toTimestampString() ?? "") để tham gia sự kiện mang tên \(event.name ?? "") cũng mình nhé!"
        
        delegate?.sharingEvent(with: contentToSharing)
        
    }
    
    @IBAction func btnLike(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        if isLiked {
            self.btnLike.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
            self.delegate?.unLikeEvent(with: event)
            self.isLiked = false
        } else {
            self.btnLike.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            self.delegate?.likeEvent(with: event)
            self.isLiked = true
        }
    }
    
}
