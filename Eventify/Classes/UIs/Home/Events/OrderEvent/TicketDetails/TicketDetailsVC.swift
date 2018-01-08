//
//  TicketDetailsVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/3/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketDetailsVC: UIViewController {
    
    var event: EventObject?
    var tickets: [TicketObject]?
    var ticketsToOrder: [TicketOrderObject] = []
    var loading = UIActivityIndicatorView()
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var tblTickets: UITableView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
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
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        
        getTickets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setTranslucent(isTranslucent: true)
    }
    
    func handlerInformations() {
        self.loading.showLoadingDialog()
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                self.lblEventName.text = self.event?.name
                self.lblBy.text = "Bởi \(self.event?.createdBy?.fullName ?? "Không rõ")"
            }
            
            if let timeStart = self.event?.timeStart, let timeEnd = self.event?.timeEnd {
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
    
    func getTickets() {
        
        guard let id = self.event?.id else {
            return
        }
        
        TicketServices.shared.getTickets(withEvent: id) { (idEvent, tickets, error) in
            if let error = error {
                self.showAlert(error, title: "Lỗi khi tải vé", buttons: nil);
                return
            }
            
            if idEvent == self.event?.id {
                self.tickets = tickets
                self.tblTickets.reloadData()
            }
        }
    }
    
    
    @IBAction func continuesClicked(_ sender: Any) {
        
        if self.ticketsToOrder.count == 0 {
            self.showAlert("Bạn chưa chọn vé", title: "Oops", buttons: nil)
            return
        }
        
        let order = OrderObject()
        order.event = self.event
        order.ticketsOrder = self.ticketsToOrder
        
        self.loading.showLoadingDialog()
        OrderServices.shared.beginOrder(order: order) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Có lỗi xảy ra", buttons: nil)
                return
            }
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoUserVC") as? InfoUserVC {
                vc.byName = self.lblBy.text
                vc.timeStart = self.lblTimeStart.text
                vc.timeEnd = self.lblTimeEnd.text
                vc.eventName = self.lblEventName.text
                vc.totalPrice = self.lblTotalPrice.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension TicketDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsOrderCell", for: indexPath) as? TicketsOrderCell, let tickets = self.tickets, tickets.count > 0 else {
            
            return UITableViewCell()
        }
        
        if let name = tickets[indexPath.row].name {
            cell.lblNameTicket.text = name
        }
        
        if let remaining = tickets[indexPath.row].quantitiesRemaining {
            cell.lblTicketAvailable.text = "còn \(remaining) vé"
        }
        
        if let price = tickets[indexPath.row].price {
            cell.lblTicketType.text = price == 0 ? "Miễn phí" : "\(price) VNĐ"
        }
        
        cell.ticket = tickets[indexPath.row]
        
        var quantity = 0
        
        self.ticketsToOrder.forEach { (ticket) in
            if ticket.id == self.tickets?[indexPath.row].id {
                quantity += 1
            }
        }
        
        cell.lblQuantity.text = quantity.toString()
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tickets = self.event?.tickets else {
            return 0
        }
        
        return tickets.count
    }
}

extension TicketDetailsVC: OrderEventDelegate {
    func chooseTicket(with ticket: TicketObject) {
        if  let totalPriceString = self.lblTotalPrice.text, let totalPrice = totalPriceString.toInt() {
            self.lblTotalPrice.text = (totalPrice + (ticket.price ?? 0)).toString()
            let ticketToOrder = TicketOrderObject()
            ticketToOrder.id = ticket.id
            self.ticketsToOrder.append(ticketToOrder)
            
        }
    }
    
    func unChooseTicket(with ticket: TicketObject) {
        if let totalPriceString = self.lblTotalPrice.text, let totalPrice = totalPriceString.toInt() {
            self.lblTotalPrice.text = (totalPrice - (ticket.price ?? 0)).toString()
            
            if let ticket = self.ticketsToOrder.first(where: { (element) -> Bool in
                return element.id == ticket.id
            }) {
                if let index = self.ticketsToOrder.index(of: ticket) {
                    self.ticketsToOrder.remove(at: index)
                }
            }
        }
    }
}
