//
//  TicketDetailsVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/3/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketDetailsVC: UIViewController {
    
    var idEvent: String?
    var eventName: String?
    var byName: String?
    var timeStart: Int?
    var timeEnd: Int?
    var tickets: [TicketObjectTest] = []
    var ticketsToOrder: [TicketOrderObjectTest] = []
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setTranslucent(isTranslucent: true)
    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        self.navigationItem.title = ""
    //        self.navigationController?.setTranslucent(isTranslucent: false)
    //        self.tabBarController?.tabBar.isHidden = false
    //    }
    
    func handlerInformations() {
        self.loading.showLoadingDialog(self)
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                self.lblEventName.text = self.eventName
                self.lblBy.text = "Bởi \(self.byName ?? "Không rõ")"
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
    @IBAction func continuesClicked(_ sender: Any) {
        
        if self.ticketsToOrder.count == 0 {
            self.showAlert("Bạn chưa chọn vé", title: "Oops", buttons: nil)
            return
        }
        
        let order = OrderObjectTest()
        order.idEvent = self.idEvent
        order.ticketsOrder = self.ticketsToOrder
        
        self.loading.showLoadingDialog(self)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsOrderCell", for: indexPath) as? TicketsOrderCell, self.tickets.count > 0 else {
            
            return UITableViewCell()
        }
        
        if let name = self.tickets[indexPath.row].name {
            cell.lblNameTicket.text = name
        }
        
        if let remaining = self.tickets[indexPath.row].quantitiesRemaining {
            cell.lblTicketAvailable.text = "còn \(remaining) vé"
        }
        
        if let price = self.tickets[indexPath.row].price {
            cell.lblTicketType.text = price == 0 ? "Miễn phí" : "\(price) VNĐ"
        }
        
        cell.ticket = self.tickets[indexPath.row]
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tickets.count
    }
}

extension TicketDetailsVC: OrderEventDelegate {
    func chooseTicket(with ticket: TicketObjectTest, quantity: Int) {
        if  let totalPriceString = self.lblTotalPrice.text, let totalPrice = totalPriceString.toInt() {
            self.lblTotalPrice.text = (totalPrice + (ticket.price ?? 0)).toString()
            print(quantity)
            
            if let index = self.ticketsToOrder.index(where: { (element) -> Bool in
                return element.idTicket == ticket.id
            }) {
                self.ticketsToOrder[index].quantityBought = quantity
            } else {
                let orderTicket = TicketOrderObjectTest()
                orderTicket.idTicket = ticket.id
                orderTicket.quantityBought = quantity
                self.ticketsToOrder.append(orderTicket)
            }
            
        }
    }
    
    func unChooseTicket(with ticket: TicketObjectTest, quantity: Int) {
        if let totalPriceString = self.lblTotalPrice.text, let totalPrice = totalPriceString.toInt() {
            self.lblTotalPrice.text = (totalPrice - (ticket.price ?? 0)).toString()
            
            if let index = self.ticketsToOrder.index(where: { (element) -> Bool in
                return ticket.id == element.idTicket
            }) {
                self.ticketsToOrder[index].quantityBought = quantity
                
                if quantity == 0 {
                    self.ticketsToOrder.remove(at: index)
                }
            }
        }
    }
}
