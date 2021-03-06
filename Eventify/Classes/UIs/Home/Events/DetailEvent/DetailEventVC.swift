//
//  DetailEventVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class DetailEventVC: UIViewController {
    
    var idEvent: String!
    var event: EventObject?
    var isLiked: Bool = false
    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var imgPreviewMaps: UIImageView!
    @IBOutlet weak var descriptionView: UIWebView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblDayStart: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lblByName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    func setUpUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        btnShare.layer.cornerRadius = 20
        btnShare.layer.borderWidth = 0.5
        btnShare.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        btnBookmark.layer.cornerRadius = 20
        btnBookmark.layer.borderWidth = 0.5
        btnBookmark.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        let tapToOpenMaps = UITapGestureRecognizer(target: self, action: #selector(self.openMaps))
        let tapToOpenMaps2 = UITapGestureRecognizer(target: self, action: #selector(self.openMaps))
        lblAddress.isUserInteractionEnabled = true
        lblAddress.addGestureRecognizer(tapToOpenMaps)
        
        imgPreviewMaps.isUserInteractionEnabled = true
        imgPreviewMaps.addGestureRecognizer(tapToOpenMaps2)
        
        self.imgAvata.layer.cornerRadius = 37.5
        self.imgAvata.clipsToBounds = true
        
        if isLiked {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
        } else {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
        }
    }
    
    func loadEvent(withId id: String) {
        self.loading.showLoadingDialog()
        EventServices.shared.getEvent(withId: id) { (event, error) in
            if let error = error {
                self.showAlert(error, title: "Loading event has been failed", buttons: nil);
            } else {
                guard let event = event else {
                    self.showAlert("Event not found", title: "error", buttons: nil)
                    return
                }
                
                self.event = event
                
                self.handlerEvent(withEvent: event)
            }
        }
    }
    
    func handlerEvent(withEvent event: EventObject) {
        
        if !self.loading.isAnimating {
            self.loading.showLoadingDialog()
        }
        
        if let photoUrl = event.photoCoverPath {
            self.imgCover.downloadedFrom(link: photoUrl)
        }
        
        //name
        self.lblName.text = event.name
        //by
        self.lblBy.text = "Bởi: \(event.createdBy?.fullName ?? "Không rõ")"
        
        
        /*
         * day start - ex: 31 thg 10, 2017
         * .get day
         * .get month
         * .get year
         */
        if let timeStart = event.timeStart, let timeEnd = event.timeEnd {
            let (dayStart, mountStart, yearStart, hourStart, minuart) = timeStart.getTime()
            let (_, _, _, hourEnd, minuteEnd) = timeEnd.getTime()
            self.lblDayStart.text = "\(dayStart) thg \(mountStart), \(yearStart)"
            self.lblDuration.text = "\(hourStart):\(minuart) - \(hourEnd):\(minuteEnd)"
            
        }
        
        //address
        self.lblAddress.text = event.address?.address ?? "Không có vị trí cho sự kiện này"
        
        
        //descriptions
        
        if let descriptionEvent = event.descriptionEvent {
            self.descriptionView.loadHTMLString(descriptionEvent, baseURL: nil)
        }
        
        //price: from $ -> to $
        
        if let tickets = event.tickets {
            self.lblPrice.text = "Từ \(Helpers.handlerPrice(for: tickets).0) - \(Helpers.handlerPrice(for: tickets).1) VNĐ"
        }
        
        
        //maps
        if let latitude = event.address?.latitude, let longtitude = event.address?.longitude {
            
            if let staticMapUrl: String = "http://maps.google.com/maps/api/staticmap?markers=color:red|\(latitude),\(longtitude)&\("zoom=18&size=\(2 * Int(self.imgPreviewMaps.frame.width))x\(2 * Int(self.imgPreviewMaps.frame.height))")&sensor=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                
                if let url = URL(string: staticMapUrl), let data = NSData(contentsOf: url) {
                    self.imgPreviewMaps.image = UIImage.convertFromData(data as Data)
                }
            }
        }
        
        //orgarnizer
        if let user = event.createdBy {
            
            if let link = user.photoDisplayPath {
                self.imgAvata.downloadedFrom(link: link)
            } else {
                self.imgAvata.image = #imageLiteral(resourceName: "avata")
            }
            
            self.lblByName.text = "\(user.fullName ?? "Không rõ")"
            self.lblPhone.text = "\(user.phoneNumber ?? "Không rõ")"
            self.lblEmail.text = "\(user.email ?? "Không rõ")"
            
        }
        
        self.loading.stopAnimating()
    }
    
    func openMaps() {
        //options: Google Maps & Apple Maps
        guard let latitude = event?.address?.latitude, let longtitude = event?.address?.longitude, let addressName = event?.address?.address, let placeId = event?.address?.placeId else {
            return
        }
        
        let alert = UIAlertController(title: "Mở bản đồ với?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let appleMap = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.default) { (btn) in
            self.openAppleMaps(latitude: latitude, longtitude: longtitude, name: addressName)
        }
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.default) { (btn) in
            self.openGoogleMaps(latitude: latitude, longtitude: longtitude, name: addressName, placeId: placeId)
        }
        
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.cancel) { (btn) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(appleMap)
        alert.addAction(googleMaps)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGoogleMaps(latitude: Double, longtitude: Double, name: String, placeId: String) {
        
        guard let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longtitude)&query_place_id=\(placeId)") else  {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    func openAppleMaps(latitude: Double, longtitude: Double, name: String) {
        let coordinate = CLLocationCoordinate2DMake(latitude,longtitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setTranslucent(isTranslucent: false)
        
        if let event = self.event {
            self.handlerEvent(withEvent: event)
        } else {
            
            guard let id = self.idEvent else {
                return
            }
            
            self.loadEvent(withId: id)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func btnAddToCalendar(_ sender: Any) {
        
        guard let name = lblName.text, let dayStart = event?.timeStart, let dateEnd = event?.timeEnd, let location = event?.address else {
            return
        }
        
        let startDate = dayStart.toDate()
        let endDate = dateEnd.toDate()
        
        let addButton = UIAlertAction(title: "Thêm ngay", style: UIAlertActionStyle.default) { (btn) in
            self.loading.showLoadingDialog()
            Helpers.addEventToCalendar(title: name, description: "", startDate: startDate, endDate: endDate, location: location, completion: { (error) in
                
                self.loading.stopAnimating()
                let cancelButton = UIAlertAction(title: "Đã hiểu", style: UIAlertActionStyle.default, handler: { (btn) in
                    
                })
                if let error = error {
                    self.showAlert(error, title: "Thêm sự kiện vào lịch thất bại", buttons: nil)
                    return
                }
                self.showAlert("Đã thêm thành công sự kiện \(name) vào ứng dụng lịch của bạn.", title: "Thêm sự kiện vào lịch thành công", buttons: [cancelButton])
            })
            
        }
        
        let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.default, handler: nil)
        
        self.showAlert("Bằng cách nhấn vào nút \("Thêm ngay"), sự kiện \(name) sẽ được thêm vào ứng dụng lịch của bạn", title: "Bạn có muốn thêm sự kiện \(name) vào lịch của bạn không?", buttons: [addButton, cancelButton])
        
    }
    
    @IBAction func btnShare(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        let contentToSharing = "Hãy đến với \(event.address?.address ?? "") vào lúc \(event.timeStart?.toTimestampString() ?? "") để tham gia sự kiện mang tên \(event.name ?? "") cũng mình nhé!"
        self.sharingEvent(with: contentToSharing)
    }
    
    @IBAction func btnLike(_ sender: Any) {
        
        guard let id = self.event?.id else {
            return
        }
        
        if isLiked {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
            self.isLiked = false
            UserServices.shared.UnlikeEvent(with: id)
            
        } else {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            self.isLiked = true
            UserServices.shared.likeEvent(with: id)
        }
    }
    
    func sharingEvent(with content: String) {
        let alertSharing = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        alertSharing.popoverPresentationController?.sourceView = self.view
        alertSharing.excludedActivityTypes = []
        self.present(alertSharing, animated: true, completion: nil)
    }
    
    @IBAction func ticketDetailsClicked(_ sender: Any) {
        
        let currentTime = Date().timeIntervalSince1970
        
        if let timeEnd = self.event?.timeEnd {
            if timeEnd <= currentTime.toInt() {
                let returnAction = UIAlertAction(title: "Xem sự kiện khác", style: UIAlertActionStyle.default, handler: nil)
                
                self.showAlert("Thành thật xin lỗi bạn, sự kiện này đã kết thúc rồi!", title: "Sự kiện đã kết thúc", buttons: [returnAction])
                return
            }
        }
        
        if let vc = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "TicketDetailsVC") as? TicketDetailsVC {
            
            vc.event = self.event
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
