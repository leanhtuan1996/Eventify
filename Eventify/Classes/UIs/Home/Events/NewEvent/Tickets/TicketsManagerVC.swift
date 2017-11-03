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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.title = "Quản lý vé"
        let newTicketItem = UIBarButtonItem(title: "Thêm vé", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.addNewTicket))
        self.navigationItem.setRightBarButton(newTicketItem, animated: true)
        self.navigationController?.setTranslucent()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        //load tickets
        loadTickets()
        //TicketManager.shared.deleteTickets()
    }
    
    func loadTickets() {
        tickets = TicketManager.shared.getTickets()
        //print(tickets.count)
        tblTickets.reloadData()
    }
  
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func addNewTicket() {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "NewTicketVC") as? NewTicketVC {
            self.navigationController?.pushViewController(sb, animated: true)
            sb.title = "Tạo vé mới"
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
            sb.title = "Chỉnh sửa vé"
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Xoá") { (rowAction, indexPath) in
            
            print(indexPath.row)
            
            self.tickets.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        return [deleteAction]
    }
}
