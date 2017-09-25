//
//  DiscoverVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController {
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var btnEvents: UIButton!
    @IBOutlet weak var btnPlaces: UIButton!
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var saparatorView: UIView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //tableview
        tblEvents.delegate = self
        tblEvents.dataSource = self
        tblEvents.register(UINib(nibName: "EventsCell", bundle: nil), forCellReuseIdentifier: "EventsCell")
        tblEvents.refreshControl = refreshControl
        
        controlView.layer.borderColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        controlView.layer.borderWidth = 2
        controlView.layer.cornerRadius = 20
        
        //btnEvents
        btnEvents.layer.cornerRadius = 20
        btnPlaces.layer.cornerRadius = 20
        
        //        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        self.cellView.layer.shadowColor = UIColor.black.cgColor
        //        self.cellView.layer.shadowRadius = 4
        //        self.cellView.layer.shadowOpacity = 0.25
        //        self.cellView.layer.masksToBounds = false;
        //        self.cellView.clipsToBounds = false;
        
        //tabbar
        
        if let items = tabBarController?.tabBar.items {
            let tabBarImages = [#imageLiteral(resourceName: "event"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "plus"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile")]
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
            }
        }
    }
    
    
    
    // MARK: - FUNCTIONS
    @objc func refresh(sender:AnyObject) {
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnEventsClicked(_ sender: Any) {
        btnEvents.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnEvents.layer.zPosition = 100
        btnEvents.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnPlaces.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnPlaces.layer.zPosition = 99
        btnPlaces.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
        
    }
    @IBAction func btnPlacesClicked(_ sender: Any) {
        btnPlaces.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnPlaces.layer.zPosition = 100
        btnPlaces.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnEvents.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnEvents.layer.zPosition = 99
        btnEvents.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
    }
    
    @IBAction func SignOut(_ sender: Any) {
        UserServices.shared.signOut()
    }
    
}

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as? EventsCell else {
            return UITableViewCell()
        }
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DetailEventVC") as? DetailEventVC {
            self.navigationController?.pushViewController(sb, animated: true)
            self.tabBarController?.hidesBottomBarWhenPushed = true
        }
    }
    
    
}
