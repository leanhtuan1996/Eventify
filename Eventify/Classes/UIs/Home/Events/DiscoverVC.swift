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
    
    var events: [EventObjectTest] = []
    var likedEvents: [String] = []
    var refreshControl: UIRefreshControl!
    var isLoadingMore = false
    var previousController: UIViewController?
    let loading = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        setUpInformations()
    }
    
    func setUpUI() {
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
        
        self.tabBarController?.delegate = self
    }
    
    func setUpInformations() {
        self.loading.showLoadingDialog(self)
        loadEvents {
            self.loadInformations {
                if self.loading.isAnimating {
                    self.tblEvents.reloadData()
                    self.loading.stopAnimating()
                }
            }
        }
    }
    
    func loadEvents(_ completionHandler: (() -> Void)?) {
        
        EventServicesTest.shared.getEvents { (events, error) in
            self.refreshControl.endRefreshing()
            
            if let error = error {
                print(error)
                return
            }
            
            if let events = events {
                self.events = events
                self.tblEvents.reloadData()
            }
            completionHandler?()
        }
    }
    
    func loadMoreEvents() {
        EventServicesTest.shared.getMoreEvents(completionHandler: { (events, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let events = events {
                if events.count == 0 { return }
                
                events.forEach({ (event) in
                    self.events.append(event)
                })
                
                self.tblEvents.reloadData()
            }
        })
    }
    
    func loadInformations(_ completionHandler: @escaping () -> Void) {
        guard let idUser = UserServicesTest.shared.currentUser?.id else {
            return
        }
        
        UserServicesTest.shared.getMyInformations() { (user, error) in
            
            print("Loading informations")
            
            if let eventLiked = user?.liked {
                eventLiked.forEach({ (event) in
                    
                    self.likedEvents.append(event.id)
                    
                })
            }
            
            return completionHandler()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblEvents.reloadData()
    }
    
    // MARK: - FUNCTIONS
    func refresh() {
        self.loadEvents(nil)
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

extension DiscoverVC: UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, InteractiveEventProtocol {
    
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
        cell.lblAddress.text = events[indexPath.row].address?.address
        cell.lblTimeStart.text = events[indexPath.row].timeStart?.toTimestampString()
        cell.lblPrice.text = "Từ \(handlerPrice(for: events[indexPath.row].tickets ?? []).0) VNĐ"
        cell.lblNameOfType.text = handlerTypes(for: events[indexPath.row].types ?? [])
        cell.delegate = self
        if let url = events[indexPath.row].photoCoverPath {
            cell.imgPhoto.downloadedFrom(path: url)
        }
        
        if let eventsLiked = UserServicesTest.shared.currentUser?.liked {
            //            if let idEvent = events[indexPath.row].id {
            //               if eventsLiked.contains(where: { (event) -> Bool in
            //                if let id = event.id {
            //                    return id == idEvent
            //                }
            //                return false
            //               }) {
            //                cell.btnLike.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            //                cell.isLiked = true
            //               } else {
            //                cell.btnLike.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
            //                cell.isLiked = false
            //                }
            //            }
            if eventsLiked.contains(where: { (event) -> Bool in
                
                return event.id == events[indexPath.row].id
                
            }) {
                cell.btnLike.setImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
                cell.isLiked = true
            } else {
                cell.btnLike.setImage(#imageLiteral(resourceName: "unlike"), for: UIControlState.normal)
                cell.isLiked = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DetailEventVC") as? DetailEventVC {
            
            if let eventsLiked = UserServicesTest.shared.currentUser?.liked {
                //                if let idEvent = events[indexPath.row].id {
                //                    if eventsLiked.contains(where: { (event) -> Bool in
                //                        if let id = event.id {
                //                            return id == idEvent
                //                        }
                //                        return false
                //                    }) {
                //                        sb.isLiked = true
                //                    } else {
                //                        sb.isLiked = false
                //                    }
                //                }-
                if eventsLiked.contains(where: { (event) -> Bool in
                    
                    return event.id == events[indexPath.row].id
                    
                }) {
                    sb.isLiked = true
                } else {
                    sb.isLiked = false
                }
            }
            
            sb.event = events[indexPath.row]
            sb.minPrice = handlerPrice(for: events[indexPath.row].tickets ?? []).0
            sb.maxPrice = handlerPrice(for: events[indexPath.row].tickets ?? []).1
            self.navigationController?.pushViewController(sb, animated: true)
            self.tabBarController?.hidesBottomBarWhenPushed = true
        }
    }
    
    func handlerPrice(for tickets: [TicketObjectTest]) -> (String, String) {
        
        if tickets.count > 0 {
            
            var min = tickets[0].price ?? 0
            var max = tickets[0].price ?? 0
            
            //Get all price in array
            for ticket in tickets {
                if let price = ticket.price {
                    min = price < min ? price : min
                    max = price > max ? price : max
                }
            }
            
            return (min.toString(), max.toString())
            
        } else {
            return ("0", "0")
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 200.0 {
            self.loadMoreEvents()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = tabBarController.selectedViewController as? UINavigationController {
            if previousController == nav.viewControllers[0] as? DiscoverVC && self.events.count > 0 {
                self.tblEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
            previousController = nav.viewControllers[0]
        }
    }
    
    //SharingProtocol
    func sharingEvent(with content: String) {
        let alertSharing = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        alertSharing.popoverPresentationController?.sourceView = self.view
        alertSharing.excludedActivityTypes = []
        self.present(alertSharing, animated: true, completion: nil)
    }
    
    func unLikeEvent(with event: EventObjectTest) {
        
        UserServicesTest.shared.UnlikeEvent(withId: event.id) { (error) in
            if let error = error {
                self.showAlert("Có lỗi không xác định đã xảy ra. \(error)", title: "Thích sự kiện thất bại", buttons: nil)
                return
            }
        }
    }
    
    func likeEvent(with event: EventObjectTest) {
        UserServicesTest.shared.likeEvent(withEvent: event) { (error) in
            if let error = error {
                self.showAlert("Có lỗi không xác định đã xảy ra. \(error)", title: "Thích sự kiện thất bại", buttons: nil)
                return
            }
        }
        
    }
    
}
