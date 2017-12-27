//
//  DetailTicketsOrderedVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class DetailTicketsOrderedVC: UIViewController {
    
    var order: OrderObject?
    
    var isfirstTimeTransform = true
    var prevIndexPath = IndexPath(row: 0, section: 0)
    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionTickets: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        collectionTickets.register(UINib(nibName: "DetailTicketsOrderedCell", bundle: nil), forCellWithReuseIdentifier: "DetailTicketsOrderedCell")
        collectionTickets.delegate = self
        collectionTickets.dataSource = self
        
        showAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if finished
            {
                self.parent?.didMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func btnReturnClicked(_ sender: Any) {
        removeAnimate()
    }
    
}

extension DetailTicketsOrderedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tickets = self.order?.ticketsOrder else {
            return 0
        }
        
        return tickets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let order = self.order, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailTicketsOrderedCell", for: indexPath) as? DetailTicketsOrderedCell else {
            return UICollectionViewCell()
        }
        
        if (indexPath.row == 0 && isfirstTimeTransform) {
            isfirstTimeTransform = false
        }else{
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        if let link = order.ticketsOrder?[indexPath.row].QRCodeImgPath {
            cell.imgQRCode.downloadedFrom(link: link)
        }
        
        cell.lblAddress.text = order.event?.address?.address ?? "Không rõ"
        cell.lblFullName.text = order.fullName ?? "Không rõ"
        cell.lblIdOfOrder.text = "#\(order.id)"
        cell.lblTimeStart.text = order.event?.timeStart?.toTimestampString()
        cell.lblNameOfEvent.text = order.event?.name ?? "Không rõ"
        cell.lblNameOfCreated.text = order.event?.createdBy?.fullName ?? "Không rõ"
        cell.lblNumberOfTickets.text = "Ticket \(indexPath.row + 1) of \(order.ticketsOrder?.count ?? 0)"
        
        cell.timeStart = order.event?.timeStart
        cell.timeEnd = order.event?.timeEnd
        cell.address = order.event?.address
        cell.idEvent = order.event?.id
        cell.delegate = self
        
        var name: String?
        
        for ticket in order.event?.tickets ?? [] {
            if ticket.id == order.ticketsOrder?[indexPath.row].id  ?? "" {
                name = ticket.name
                break
            }
        }
        
        cell.lblNameOfTicket.text = name ?? "Không rõ"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let pageWidth = Float(self.view.bounds.width)
        let minSpace: Float = 5.0
        let cellToSwipe: Double = Double(Float((scrollView.contentOffset.x))/Float(pageWidth+minSpace)) + Double(0.5)
        
        let newIndexPath = IndexPath(row: Int(cellToSwipe), section:0)
        let newCell = self.collectionTickets.cellForItem(at: newIndexPath)
        let prevCell = self.collectionTickets.cellForItem(at: prevIndexPath)
        
        
        self.collectionTickets.scrollToItem(at: newIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            newCell?.transform = CGAffineTransform.identity
        }) { (finished) in
            
            if newIndexPath.row != self.prevIndexPath.row {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                    prevCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: nil)
            }
            
            self.prevIndexPath = newIndexPath
        }
    }
}

extension DetailTicketsOrderedVC: ActionTicketDelegate {
    func addToCalendar(withName name: String, start dateStart: Int, end dateEnd: Int, andLocation location: AddressObject) -> Void {
        
        let startDate = dateStart.toDate()
        let endDate = dateEnd.toDate()
        
        let addButton = UIAlertAction(title: "Thêm ngay", style: UIAlertActionStyle.default) { (btn) in
            self.loading.showLoadingDialog(self)
            Helpers.addEventToCalendar(title: name, description: "", startDate: startDate, endDate: endDate, location: location, completion: { (error) in
                
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
    
    func viewMap(address: AddressObject) -> Void {
        
        guard let latitude = address.latitude, let longtitude = address.longitude, let addressName = address.address else {
            return
        }
        
        let alert = UIAlertController(title: "Mở bản đồ với?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let appleMap = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.default) { (btn) in
            self.openAppleMaps(latitude: latitude, longtitude: longtitude, name: addressName)
        }
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.default) { (btn) in
            self.openGoogleMaps(latitude: latitude, longtitude: longtitude, name: addressName, placeId: address.placeId)
        }
        
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.cancel) { (btn) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(appleMap)
        alert.addAction(googleMaps)
        self.present(alert, animated: true, completion: nil)
    }
    func viewEvent(withId id: String) -> Void {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailEventVC") as? DetailEventVC else {
            return
        }
        
        vc.idEvent = id
        
        if let likes = UserManager.shared.currentUser?.liked {
            if likes.contains(where: { (event) -> Bool in
                return event.id == id
            }) {
                vc.isLiked = true
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
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
}
