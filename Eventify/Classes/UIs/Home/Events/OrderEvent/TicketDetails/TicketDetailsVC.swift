//
//  TicketDetailsVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/3/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketDetailsVC: UIViewController {
    
    var eventName: String?
    var byName: String?
    var timeStart: Int?
    var timeEnd: Int?
    var tickets: [TicketObject] = []
    var loading = UIActivityIndicatorView()
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var tblTickets: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTickets.register(UINib(nibName: "TicketsOrderCell", bundle: nil), forCellReuseIdentifier: "TicketsOrderCell")
        tblTickets.estimatedRowHeight = 65
        tblTickets.delegate = self
        tblTickets.dataSource = self
        
        self.handlerInformations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.navigationController?.setTranslucent()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func handlerInformations() {
        self.loading.showLoadingDialog(self)
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                self.lblEventName.text = self.eventName
                self.lblBy.text = self.byName
            }
            
            if let timeStart = self.timeStart, let timeEnd = self.timeEnd {
                //day - month - year - hour - minute
                let (dayOfWeek, day, month, year, hour, minute) = timeStart.getTime()
                let (dayOfWeek_end, day_end, month_end, year_end, hour_end, minute_end) = timeEnd.getTime()
                
                DispatchQueue.main.async {
                    self.lblTimeStart.text = "Thứ \(dayOfWeek), ngày \(day) tháng \(month), \(year) vào lúc \(hour):\(minute)0"
                    self.lblTimeEnd.text = "Thứ \(dayOfWeek_end), ngày \(day_end) tháng \(month_end), \(year_end) vào lúc \(hour_end):\(minute_end)0"
                }
                
            }
            
            DispatchQueue.main.async {
                self.loading.stopAnimating()
            }
            
        }
    }
    
}

extension TicketDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsOrderCell", for: indexPath) as? TicketsOrderCell, self.tickets.count > 0 else {
            
            return UITableViewCell()
        }
        
        if let name = self.tickets[indexPath.row].name {
            cell.lblNameTicket.text = name
        }
        
        if let quantity = self.tickets[indexPath.row].quantity {
            cell.lblTicketAvailable.text = "còn \(quantity) vé"
        }
        
        if let price = self.tickets[indexPath.row].price {
            cell.lblTicketType.text = price == 0 ? "Miễn phí" : "\(price) VNĐ"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tickets.count == 0 ? 2 : self.tickets.count
    }
}
