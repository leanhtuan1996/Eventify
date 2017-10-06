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

    var titleString: String?
    var ticketObject = TicketObject()
    @IBOutlet weak var txtNameTicket: SkyFloatingLabelTextField!
     @IBOutlet weak var txtDescription: SkyFloatingLabelTextField!
     @IBOutlet weak var txtQuantity: SkyFloatingLabelTextField!
     @IBOutlet weak var txtPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var lblTitleVC: UILabel!
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
        
        lblTitleVC.text = titleString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        
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
    
    @IBAction func btnMoreClicked(_ sender: Any) {
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
