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
    
    var minPrice: String?
    var maxPrice: String?
    var event: EventObject!
    let loading = UIActivityIndicatorView()
    var isLiked = false
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblDateStart: UILabel!
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
        handlerEvent()
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
        lblAddress.isUserInteractionEnabled = true
        lblAddress.addGestureRecognizer(tapToOpenMaps)
        
        self.imgAvata.layer.cornerRadius = 37.5
        self.imgAvata.clipsToBounds = true
        
        if isLiked {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
        } else {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
        }
    }
    
    func handlerEvent() {
        
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
        self.lblAddress.text = event.address?.address ?? "Không có vị trí cho sự kiện này"
        
        //descriptions
        self.lblDescriptions.text = event.descriptionEvent ?? "Không có mô tả cho sự kiện này"
        
        //price: from $ -> to $
        if let minPrice = self.minPrice, let maxPrice = self.maxPrice {
            self.lblPrice.text = "Từ \(minPrice) - \(maxPrice) VNĐ"
        }
        
        //maps
        if let latitude = self.event.address?.latitude, let longtitude = self.event.address?.longtutude, let addressName = self.event.address?.address {
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 8.0)
            self.mapView.animate(to: camera)
            self.addMarker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), eventName: self.event.name ?? "Sự kiện không xác định", address: addressName)
        }
        
        //orgernize
        if let user = event.by {
            
            if let link = user.photoURL {
                self.imgAvata.downloadedFrom(link: link)
            } else {
                self.imgAvata.image = #imageLiteral(resourceName: "avatar")
            }
            
            self.lblByName.text = "\(user.fullName ?? "Không rõ")"
            self.lblPhone.text = "\(user.phone ?? "Không rõ")"
            self.lblEmail.text = "\(user.email ?? "Không rõ")"
            
        }
        
        
        //isLike?
        
        loading.stopAnimating()
    }
    
    func openMaps() {
        //options: Google Maps & Apple Maps
        guard let latitude = event.address?.latitude, let longtitude = event.address?.longtutude, let addressName = event.address?.address, let placeId = event.address?.placeId else {
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
                
                let cancelButton = UIAlertAction(title: "Đã hiểu", style: UIAlertActionStyle.default, handler: { (btn) in
                    self.loading.stopAnimating()
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
    
    @IBAction func btnShowMoreDiscriptions(_ sender: Any) {
    }
    
    @IBAction func btnShare(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        let contentToSharing = "Hãy đến với \(event.address?.address ?? "") vào lúc \(event.timeStart?.toTimestampString() ?? "") để tham gia sự kiện mang tên \(event.name ?? "") cũng mình nhé!"
        self.sharingEvent(with: contentToSharing)
    }
    
    @IBAction func btnLike(_ sender: Any) {
        guard let event = self.event else {
            return
        }
        
        if isLiked {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
            self.isLiked = false
            guard let id = self.event.id else {
                return
            }
            
            UserServices.shared.UnlikeEvent(withId: id) { (error) in
                if let error = error {
                    self.showAlert("Có lỗi không xác định đã xảy ra. \(error)", title: "Thích sự kiện thất bại", buttons: nil)
                    return
                }
            }
            
        } else {
            self.btnBookmark.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            self.isLiked = true
            UserServices.shared.likeEvent(withEvent: event, completionHandler: { (error) in
                if let error = error {
                    self.showAlert("Có lỗi không xác định đã xảy ra. \(error)", title: "Thích sự kiện thất bại", buttons: nil)
                    return
                }
            })
        }
    }
    
    func sharingEvent(with content: String) {
        let alertSharing = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        alertSharing.popoverPresentationController?.sourceView = self.view
        alertSharing.excludedActivityTypes = []
        self.present(alertSharing, animated: true, completion: nil)
    }
}

extension DetailEventVC {
    func addMarker(coordinate: CLLocationCoordinate2D, eventName: String, address: String) {
        let marker = GMSMarker()
        self.mapView.clear()
        marker.position = coordinate
        marker.title = eventName
        marker.snippet = address
        marker.appearAnimation = .pop
        marker.isDraggable = true
        marker.isFlat = true
        marker.map = mapView
    }
    
    
}
