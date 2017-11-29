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
    
    var ticketObject: TicketObjectTest?
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
        
        if let ticket = self.ticketObject {
            txtNameTicket.text = ticket.name
            txtQuantity.text = ticket.quantity?.toString()
            txtPrice.text = ticket.price?.toString()
            txtDescription.text = ticket.descriptions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        let newTicketItem = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        self.navigationItem.setRightBarButton(newTicketItem, animated: true)
        self.navigationController?.setTranslucent(isTranslucent: true)
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
        
        
        txtNameTicket.errorMessage = ""
        txtQuantity.errorMessage = ""
        
        self.dismissKeyboard()
        //TicketManager.shared.addTicket(with: ticket)
        self.loading.showLoadingDialog(self)
        //edit, else => add
        if let ticket = self.ticketObject {
            ticket.name = txtNameTicket.text
            ticket.descriptions = txtDescription.text
            ticket.quantity = txtQuantity.text?.toInt()
            ticket.price = txtPrice.text?.toInt()
            
            TicketServicesTest.shared.editTicket(with: ticket, completionHandler: { (error) in
                self.loading.stopAnimating()
                
                let backButton = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.default, handler: { (btn) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                if let error = error {
                    self.showAlert(error, title: "Add new ticket has been failed", buttons: [backButton])
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            
            let ticketTest = TicketObjectTest()
            ticketTest.name = txtNameTicket.text
            ticketTest.descriptions = txtDescription.text
            ticketTest.quantity = txtQuantity.text?.toInt()
            ticketTest.price = txtPrice.text?.toInt()
            
            TicketServicesTest.shared.addTicket(with: ticketTest, completionHandler: { (error) in
                self.loading.stopAnimating()
                
                let backButton = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.default, handler: { (btn) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                if let error = error {
                    self.showAlert(error, title: "Add new ticket has been failed", buttons: [backButton])
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            })
            
//            TicketServices.shared.addTicket(with: ticket) { (error) in
//                self.loading.stopAnimating()
//                
//                let backButton = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.default, handler: { (btn) in
//                    self.navigationController?.popViewController(animated: true)
//                })
//                
//                if let error = error {
//                    self.showAlert(error, title: "Add new ticket has been failed", buttons: [backButton])
//                    return
//                }
//                
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtNameTicket, !textField.hasText {
            txtNameTicket.errorMessage = "Vui lòng nhập tên vé"
            return
        } else {
            txtNameTicket.errorMessage = ""
        }
        
        if textField == self.txtQuantity, !textField.hasText {
            txtQuantity.errorMessage = "Vui lòng nhập số lượng vé"
            return
        } else {
            txtQuantity.errorMessage = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if !textField.hasText {
            
            if textField == txtQuantity {
                txtQuantity.errorMessage = ""
            }
            
            return
        }
        
        if textField == txtQuantity, let text = textField.text, !text.isInt() {
            txtQuantity.errorMessage = "Vui lòng nhập số"
        }
    }
    
}
