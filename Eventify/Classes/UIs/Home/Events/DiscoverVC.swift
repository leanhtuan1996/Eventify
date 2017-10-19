//
//  DiscoverVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/24/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Dollar

class DiscoverVC: UIViewController {
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var btnEvents: UIButton!
    @IBOutlet weak var btnPlaces: UIButton!
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var saparatorView: UIView!
    
    var events: [EventObject] = []
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
        tblEvents.estimatedRowHeight = 370
        
        controlView.layer.borderColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1).cgColor
        controlView.layer.borderWidth = 2
        controlView.layer.cornerRadius = 20
        
        //btnEvents
        btnEvents.layer.cornerRadius = 20
        btnPlaces.layer.cornerRadius = 20
        
        //tabbar
        if let items = tabBarController?.tabBar.items {
            let tabBarImages = [#imageLiteral(resourceName: "event"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "plus"), #imageLiteral(resourceName: "alert"), #imageLiteral(resourceName: "more")]
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
                if i != 2 {
                    tabBarItem.imageInsets = UIEdgeInsets( top: 5, left: 0, bottom: -5, right: 0)
                } else {
                    tabBarItem.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
                }
            }
        }
        
        loadEvents()
    }
   
    
    func loadEvents() {
        EventServicesTest.shared.getEvents() { (events, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let events = events {
                //self.events = events
                
                events.forEach({ (event) in
                    self.events.append(event)
                })
                
                self.tblEvents.reloadData()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
}

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as? EventsCell else {
            return UITableViewCell()
        }
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        
        cell.event = events[indexPath.row]
        cell.lblName.text = events[indexPath.row].name
        cell.lblAddress.text = events[indexPath.row].address
        cell.lblTimeStart.text = events[indexPath.row].timeStart?.toTimestampString()
        cell.lblPrice.text = "Từ \(handlerPrice(for: events[indexPath.row].tickets ?? [])) VNĐ"
        cell.lblNameOfType.text = handlerTypes(for: events[indexPath.row].types ?? [])
        if let url = events[indexPath.row].photoURL {
            cell.imgPhoto.downloadedFrom(link: url)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DetailEventVC") as? DetailEventVC {
            sb.event = events[indexPath.row]
            sb.minPrice = handlerPrice(for: events[indexPath.row].tickets ?? [])
            self.navigationController?.pushViewController(sb, animated: true)
            self.tabBarController?.hidesBottomBarWhenPushed = true
        }
    }
    
    func handlerPrice(for tickets: [TicketObject]) -> String {
        
        if tickets.count > 0{
           
            var min = tickets[0].price ?? 0
            
            //Get all price in array
            for ticket in tickets {
                if let price = ticket.price {
                    min = price < min ? price : min
                }
            }
            
            return min.toString()
            
        } else {
            return "0"
        }
        
    }
    
    func handlerTypes(for types: [EventTypeObject]) -> String {
       
        var string = ""
        
        var index = 0
        for type in types {
            if index != types.count - 1 {
                string += (type.name ?? "") + ", "
            } else {
                string += (type.name ?? "")
            }
            index += 1
        }
        
        
        return string
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.events.count - 3) {
            self.loadEvents()
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        // UITableView only moves in one direction, y axis
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        
//        if maximumOffset - currentOffset <= 400.0 {
//           self.loadEvents()
//        }
//
//    }
    
}
