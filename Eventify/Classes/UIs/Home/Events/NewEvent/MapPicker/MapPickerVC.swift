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
    
    @IBOutlet weak var mapView: GMSMapView!
    let loading = UIActivityIndicatorView()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var isAuth = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
    }
    
    func setUpMapView() {
        self.loading.showLoadingDialog(self)
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: self.zoomLevel)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
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
            return false
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
            self.showAlert("Nhấn vào nút \("Cài đăt") để bật dịch vụ vị trí hiện tại của bạn", title: "Dịch vụ vị trí hiện đang bị tắt", buttons: [settingsAction, cancelButton])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = self.mapView
    }
    
}

extension MapPickerVC: GMSMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.addMarker(coordinate: coordinate)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if checkServiceLocation() {
            return true
        }
        
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: self.zoomLevel)
            self.mapView.camera = camera
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
}
