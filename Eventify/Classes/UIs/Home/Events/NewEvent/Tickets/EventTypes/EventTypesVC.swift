//
//  EventTypesVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/6/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EventTypesVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    var eventTypes: [TypeObject] = []
    @IBOutlet weak var tblTypes: UITableView!
    var delegate: EventDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEventTypes()
        showAnimate()
        popupView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        
        //table view
        tblTypes.delegate = self
        tblTypes.dataSource = self
        tblTypes.estimatedRowHeight = 40
        tblTypes.register(UINib(nibName: "EventTypeCell", bundle: nil), forCellReuseIdentifier: "EventTypeCell")
        
    }

    @IBAction func btnQuitTapped(_ sender: Any) {
        removeAnimate()
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
                print("QUIT")
                self.didMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    
    func loadEventTypes() {
        TypeEventServices.shared.getTypesEvent { (types, error) in
            if let error = error {
                print(error)
                return
            }
            if let types = types {
                self.eventTypes = types
                self.tblTypes.reloadData()
            }
        }
        
        
//        TypeEventServices.shared.getTypesEvent { (types, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            if let types = types {
//                self.eventTypes = types
//                self.tblTypes.reloadData()
//            }
//        }
    }
  
}

extension EventTypesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTypeCell", for: indexPath) as? EventTypeCell else {
            return UITableViewCell()
        }
        cell.eventType = eventTypes[indexPath.row]
        cell.lblName.text = eventTypes[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate.selectedType(with: self.eventTypes[indexPath.row])
        removeAnimate()
    }
    
    
}

