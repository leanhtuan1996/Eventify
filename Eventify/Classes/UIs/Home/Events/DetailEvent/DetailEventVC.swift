//
//  DetailEventVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailEventVC: UIViewController {
    
    var minPrice: String?
    var maxPrice: String?
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
        btnShare.layer.cornerRadius = 20
        btnShare.layer.borderWidth = 0.5
        btnShare.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        btnBookmark.layer.cornerRadius = 20
        btnBookmark.layer.borderWidth = 0.5
        btnBookmark.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
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
        
        //price: from $ -> to $
        if let minPrice = self.minPrice, let maxPrice = self.maxPrice {
            self.lblPrice.text = "Từ \(minPrice) - \(maxPrice) VNĐ"
        }
        
        //maps
        
        //isLike?
        
        return completionHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnAddToCalendar(_ sender: Any) {
        
        guard let name = lblName.text, let dateStart = event.timeStart, let dateEnd = event.timeEnd, let location = event.address else {
            return
        }
        
        let startDate = dateStart.toDate()
        let endDate = dateEnd.toDate()
        
        let addButton = UIAlertAction(title: "Thêm ngay", style: UIAlertActionStyle.default) { (btn) in
            self.loading.showLoadingDialog(self)
            Helpers.addEventToCalendar(title: name, description: self.lblDescriptions.text, startDate: startDate, endDate: endDate, location: location, completion: { (error) in
                
                self.loading.stopAnimating()
                if let error = error {
                    self.showAlert(error, title: "Thêm sự kiện vào lịch thất bại", buttons: nil)
                    return
                }
                self.showAlert("Đã thêm thành công sự kiện \(name) vào ứng dụng lịch của bạn.", title: "Thêm sự kiện vào lịch thành công", buttons: nil)
            })
            
        }
        
        let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.default, handler: nil)
        
        self.showAlert("Bằng cách nhấn vào nút \("Thêm ngay"), sự kiện \(name) sẽ được thêm vào ứng dụng lịch của bạn", title: "Bạn có muốn thêm sự kiện \(name) vào lịch của bạn không?", buttons: [addButton, cancelButton])
        
    }
    @IBAction func btnShowMoreDiscriptions(_ sender: Any) {
    }
    
}
