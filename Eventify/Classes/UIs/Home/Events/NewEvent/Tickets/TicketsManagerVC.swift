//
//  TicketsManagerVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketsManagerVC: UIViewController {

    @IBOutlet weak var tblTickets: UITableView!
    var tickets: [TicketObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTickets.delegate = self
        tblTickets.dataSource = self
        tblTickets.register(UINib(nibName: "TicketCells", bundle: nil), forCellReuseIdentifier: "TicketCells")
        tblTickets.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        //load tickets
        loadTickets()
        //TicketManager.shared.deleteTickets()
    }
    
    func loadTickets() {
        tickets = TicketManager.shared.getTickets()
        print(tickets.count)
        tblTickets.reloadData()
    }
  
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAddClicked(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "NewTicketVC") as? NewTicketVC {
            self.navigationController?.pushViewController(sb, animated: true)
            sb.titleString = "Tạo vé mới"
        }
    }
}

extension TicketsManagerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCells", for: indexPath) as? TicketCells else {
            return UITableViewCell()
        }
        
        cell.ticketObject = tickets[indexPath.row]
        cell.lblNameTicket.text = tickets[indexPath.row].name
        cell.lblPrice.text = (tickets[indexPath.row].price?.toString() ?? "") + " VND"
        cell.lblQuantitySold.text = tickets[indexPath.row].quantity?.toString()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "NewTicketVC") as? NewTicketVC {
            sb.ticketObject = tickets[indexPath.row]
            sb.titleString = "Chỉnh sửa vé"
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
}
