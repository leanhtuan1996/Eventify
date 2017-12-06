//
//  DetailTicketsOrderedVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailTicketsOrderedVC: UIViewController {
    
    var order: OrderObject?
    
    var isfirstTimeTransform = true
    var prevIndexPath = IndexPath(row: 0, section: 0)
    
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let pageWidth = Float(self.view.bounds.width)
        let minSpace: Float = 10.0
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




