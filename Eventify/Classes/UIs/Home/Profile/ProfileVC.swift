//
//  ProfileVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let loading = UIActivityIndicatorView()
    var infoView: InfoUserView = .tickets
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tblProfile: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = 50
        
        tblProfile.delegate = self
        tblProfile.dataSource = self
        tblProfile.estimatedRowHeight = 90
        tblProfile.register(UINib(nibName: "TicketsOrderedCell", bundle: nil), forCellReuseIdentifier: "TicketsOrderedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        OrderServices.shared.getOrders { (error) in
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
                return
            }
            self.tblProfile.reloadData()
        }
        
        if let user = UserManager.shared.currentUser {
            lblName.text = user.fullName
            lblEmail.text = user.email
            
            if let photoUrl = user.photoDisplayPath {
                self.imgAvatar.downloadedFrom(link: photoUrl)
            } else {
                self.imgAvatar.image = #imageLiteral(resourceName: "avatar")
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @IBAction func btnEditProfileClicked(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
    @IBAction func btnTicketsClicked(_ sender: Any) {
        self.infoView = .tickets
        self.tblProfile.reloadData()
    }
    
    @IBAction func btnSavedEventsClicked(_ sender: Any) {
        self.infoView = .liked
        self.tblProfile.reloadData()
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let user = UserManager.shared.currentUser else {
            return UITableViewCell()
        }
        
        switch self.infoView {
        case .tickets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsOrderedCell", for: indexPath) as? TicketsOrderedCell, let orders = user.orders else {
                return UITableViewCell()
            }
            
            cell.lblTotalTickets.text = "\(orders[indexPath.row].ticketsOrder?.count ?? 0) vé"
            cell.lblLocation.text = orders[indexPath.row].event?.address?.address
            cell.lblNameEvent.text = orders[indexPath.row].event?.name
            cell.lblTimeStart.text = orders[indexPath.row].event?.timeStart?.toTimestampString()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let user = UserManager.shared.currentUser else {
            return 0
        }
        
        switch self.infoView {
        case .tickets:
            guard let orders = user.orders else {
                return 0
            }
            return orders.count
        default:
            guard let likes = user.liked else {
                return 0
            }
            return likes.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.infoView {
        case .tickets:
            print("tickets")
        default:
            print("likes")
        }
    }
}


