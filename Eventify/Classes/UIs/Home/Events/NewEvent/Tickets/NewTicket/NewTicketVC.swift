//
//  NewTicketVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class NewTicketVC: UIViewController, UITextFieldDelegate {

    var ticketObject = TicketObject()
    @IBOutlet weak var txtNameTicket: SkyFloatingLabelTextField!
     @IBOutlet weak var txtDescription: SkyFloatingLabelTextField!
     @IBOutlet weak var txtQuantity: SkyFloatingLabelTextField!
     @IBOutlet weak var txtPrice: SkyFloatingLabelTextField!
   
    let loading = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNameTicket.delegate = self
        txtDescription.delegate = self
        txtQuantity.delegate = self
        txtPrice.delegate = self
        
        txtNameTicket.text = ticketObject.name
        txtQuantity.text = ticketObject.quantity?.toString()
        txtPrice.text = ticketObject.price?.toString()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        let newTicketItem = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        self.navigationItem.setRightBarButton(newTicketItem, animated: true)
        self.navigationController?.setTranslucent()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
    }
    
    func done() {
        
        if !txtNameTicket.hasText {
            txtNameTicket.errorMessage = "Trường này là bắt buộc"
        }
        
        if !txtQuantity.hasText {
            txtQuantity.errorMessage = "Trường này là bắt buộc"
            return
        }
        loading.showLoadingDialog(self)
        
        txtNameTicket.errorMessage = ""
        txtQuantity.errorMessage = ""
        
        let ticket = TicketObject()
        ticket.id = ticketObject.id
        ticket.name = txtNameTicket.text
        ticket.descriptions = txtDescription.text
        ticket.quantity = txtQuantity.text?.toInt()
        ticket.price = txtPrice.text?.toInt()
        TicketManager.shared.addTicket(with: ticket)
        loading.stopAnimating()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //validate name
        if !txtNameTicket.hasText {
            txtNameTicket.errorMessage = "Trường này là bắt buộc"
        } else {
            txtNameTicket.errorMessage = ""
        }
        
        if !txtQuantity.hasText {
            txtQuantity.errorMessage = "Trường này là bắt buộc"
        } else {
            txtQuantity.errorMessage = ""
        }
        
        if let _ = txtQuantity.text?.toInt() {
            txtQuantity.errorMessage = ""
        } else {
            txtQuantity.errorMessage = "Vui lòng nhập số"
        }
        
    }
    
}
