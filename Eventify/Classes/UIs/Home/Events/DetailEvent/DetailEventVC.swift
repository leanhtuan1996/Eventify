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
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //btnLabel.layer.cornerRadius = 15
        
        if let photoUrl = event.photoURL {
            imgCover.downloadedFrom(path: photoUrl)
        }
        lblName.text = event.name
        lblPrice.text = "Từ \(minPrice ?? "0") VNĐ"
        lblTimeStart.text = "Bắt đầu lúc: \(event.timeStart?.toTimestampString() ?? "Không rõ")"
        lblTimeEnd.text = "Kết thúc lúc: \(event.timeEnd?.toTimestampString() ?? "Không rõ")"
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
