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
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblDateStart: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    let loading = UIActivityIndicatorView()
    
    //button
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //btnLabel.layer.cornerRadius = 15
        
        
//        lblName.text = event.name
//        lblPrice.text = "Từ \(minPrice ?? "0") VNĐ"
//        lblTimeStart.text = "Bắt đầu lúc: \(event.timeStart?.toTimestampString() ?? "Không rõ")"
//        lblTimeEnd.text = "Kết thúc lúc: \(event.timeEnd?.toTimestampString() ?? "Không rõ")"
//        lblDescriptions.text = event.descriptionEvent ?? "Không có chi tiết sự kiện để hiển thị ngay lúc này"
//        lblAddress.text = "Địa chỉ: \(event.address ?? "Không rõ")"
        btnShare.layer.cornerRadius = 20
        btnShare.layer.borderWidth = 0.5
        btnShare.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        btnBookmark.layer.cornerRadius = 20
        btnBookmark.layer.borderWidth = 0.5
        btnBookmark.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        
        self.handlerEvent {
            self.loading.stopAnimating()
        }
    }
    
    func handlerEvent(completionHandler: @escaping () -> Void) {
        
        //loading
        loading.showLoadingDialog(self)
        
        //image cover
        if let photoUrl = event.photoURL {
            imgCover.downloadedFrom(path: photoUrl)
        }
        
        //name
        self.lblName.text = event.name
        //by
        self.lblBy.text = "Bởi: \(event.by?.fullName ?? "Không rõ")"
        /*
         * day start - ex: 31 thg 10, 2017
         * .get day
         * .get month
         * .get year
         */
        if let timeStart = event.timeStart, let timeEnd = event.timeEnd {
            let (dayStart, mountStart, yearStart, hourStart, minuteStart) = timeStart.getTime()
            let (_, _, _, hourEnd, minuteEnd) = timeEnd.getTime()
            self.lblDateStart.text = "\(dayStart) thg \(mountStart), \(yearStart)"
            self.lblDuration.text = "\(hourStart):\(minuteStart) - \(hourEnd):\(minuteEnd)"
        }
        
        //address
        self.lblAddress.text = event.address ?? "Không có vị trí cho sự kiện này"
        
        //descriptions
        self.lblDescriptions.text = event.descriptionEvent ?? "Không có mô tả cho sự kiện này"
        
        //maps
        
        //price: from $ -> to $
        
        //isLike?
        
        completionHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnAddToCalendar(_ sender: Any) {
    }
    @IBAction func btnShowMoreDiscriptions(_ sender: Any) {
    }
    
}
