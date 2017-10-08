//
//  DetailEventVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailEventVC: UIViewController {
    
    var minPrice: String!
    var event: EventObject!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //btnLabel.layer.cornerRadius = 15
        
        if let photoUrl = event.photoURL {
            imgCover.downloadedFrom(link: photoUrl)
        }
        lblName.text = event.name
        lblPrice.text = "Từ \(minPrice ?? "0") VNĐ"
        
        if let timeStart = event.timeStart?.toTimestampString() {
            lblTimeStart.text = "Bắt đầu lúc: \(timeStart)"
        } else {
            lblTimeStart.text = "Bắt đầu lúc: N/A"
        }
        
        lblDescriptions.text = event.descriptionEvent ?? "Không có chi tiết sự kiện để hiển thị ngay lúc này"
        lblAddress.text = "Địa chỉ: \(event.address ?? "Không rõ")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
}
