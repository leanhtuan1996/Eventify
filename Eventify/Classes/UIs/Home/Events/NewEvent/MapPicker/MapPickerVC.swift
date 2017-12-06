//
//  MapPickerVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/26/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapPickerVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var mapView: GMSMapView!
    
    //loadingDialog
    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var searchView: UIView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 10.0
    var isAuth = false
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var delegate: EventDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.layer.cornerRadius = 10
        searchView.layer.shadowColor = UIColor.blue.cgColor
        searchView.layer.shadowOffset = CGSize(width: 1, height: 1)
        setUpMapView()
    }
    
    func setUpMapView() {
        self.loading.showLoadingDialog(self)
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: self.zoomLevel)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.mapType = .normal
        self.addMarker(coordinate: CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20))
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        self.isAuth = checkServiceLocation()
        
        self.loading.stopAnimating()
    }
    
    func checkServiceLocation() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .denied, .notDetermined, .restricted:
                
                let settingsAction = UIAlertAction(title: "Cài đặt", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                
                let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.default, handler: nil)
                self.showAlert("Nhấn vào nút \("Cài đăt") để cho phép ứng dụng được sử dụng vị trí hiện tại của bạn", title: "Yêu cầu quyền truy cập vào vị trí của bạn", buttons: [settingsAction, cancelButton])
                return false
            }
            
        } else {
            let settingsAction = UIAlertAction(title: "Cài đặt", style: .default) { (_) -> Void in
                if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
            }
            
            let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.default, handler: nil)
            self.showAlert("Nhấn vào nút \("Cài đăt") để bật dịch vụ vị trí hiện tại của bạn", title: "Dịch vụ vị trí hiện đang bị tắt", buttons: [settingsAction, cancelButton])
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.backItem?.title = "Trở về"
//        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func done() {
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        self.mapView.clear()
        marker.position = coordinate
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.appearAnimation = .pop
        marker.isDraggable = true
        marker.isFlat = true
        marker.map = mapView
    }
    
    func showAddressPickerAlert(with address: AddressObject) {
        if let addressName = address.address {
            let alert = UIAlertController(title: "Đã chọn được vị trí", message: addressName, preferredStyle: UIAlertControllerStyle.actionSheet)
            let chooseAction = UIAlertAction(title: "Chọn địa chỉ này", style: UIAlertActionStyle.default, handler: { (btn) in
                
                self.delegate.selectedAddress(with: address)
                self.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.cancel, handler: { (btn) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(chooseAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MapPickerVC: GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.addMarker(coordinate: coordinate)
        //self.getAddressForLatLng(latitude: String(format: "%@",coordinate.latitude), longitude:String(format: "%@",coordinate.longitude))
        //print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
        GoogleMapsServices.shared.getAddressForLatLng(latitude: (coordinate.latitude.toString()), longitude: coordinate.longitude.toString()) { (address, error) in
            if let error = error {
                print(error)
                return
            }
            if let address = address {
                self.showAddressPickerAlert(with: address)
            }
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
        let address = AddressObject()
        address.placeId = placeID
        address.address = name
        address.latitude = location.latitude
        address.longitude = location.longitude
        self.showAddressPickerAlert(with: address)
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if checkServiceLocation() {
            return false
        }
        
        return true
    }
    
    
    
    //CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        guard let lastestLocation = locations.last else {
            return
        }
        
        //chage camera of mapView
        let camera = GMSCameraPosition.camera(withLatitude: lastestLocation.coordinate.latitude, longitude: lastestLocation.coordinate.longitude, zoom: self.zoomLevel)
        self.mapView.camera = camera
        
    }
}
