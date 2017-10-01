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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        //load tickets
        loadTickets()
    }
    
    func loadTickets() {
        tickets = TicketManager.shared.getTickets()
        print(tickets.count)
        tblTickets.reloadData()
    }
  
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnMoreClicked(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "NewTicketVC") as? NewTicketVC {
            self.navigationController?.pushViewController(sb, animated: true)
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
        
        return cell
        
    }
}
