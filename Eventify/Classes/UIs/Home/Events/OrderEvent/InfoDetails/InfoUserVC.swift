//
//  InfoUserVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/5/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class InfoUserVC: UIViewController {

    var eventName: String?
    var byName: String?
    var timeStart: String?
    var timeEnd: String?
    var totalPrice: String?
    var tickets: [TicketObject] = []
    var ticketsToOrder: [TicketObject] = []
    var loading = UIActivityIndicatorView()
    let remainingTime = 720
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var txtFullName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
    }
    
    func setUpUi() {
        
        let continuesItem = UIBarButtonItem(title: "Tiếp tục", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.continues))
        
        self.navigationItem.setRightBarButton(continuesItem, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        
        self.lblEventName.text = self.eventName
        self.lblTotalPrice.text = self.totalPrice
        self.lblTimeStart.text = self.timeStart
        self.lblTimeEnd.text = self.timeEnd
        self.lblBy.text = self.byName
        
        if let user = UserServices.shared.currentUser {
            txtFullName.text = user.fullName
            txtPhoneNumber.text = user.phone
            //txtEmail.text = user.email
            //txtAddress.text = user.address
        }
        
        txtFullName.delegate = self
        txtPhoneNumber.delegate = self
        //txtEmail.delegate = self
        //txtAddress.delegate = self
        
        //self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.remainingOrder), userInfo: nil, repeats: true)
    }
    
    @IBAction func btnContinues(_ sender: Any) {
        continues()
    }
    
    func continues() {
//        if !self.txtEmail.hasText {
//            self.txtEmail.errorMessage = "Vui lòng nhập Email"
//        }
//        
//        if !self.txtAddress.hasText {
//            self.txtAddress.errorMessage = "Vui lòng nhập Địa chỉ"
//        }
        
        if !self.txtFullName.hasText {
            self.txtFullName.errorMessage = "Vui lòng nhập Họ và Tên"
        }
        
        if !self.txtPhoneNumber.hasText {
            self.txtPhoneNumber.errorMessage = "Vui lòng nhập số điện thoại"
            return
        }
        
        guard let fullName = self.txtFullName.text, let phone = self.txtPhoneNumber.text else {
            self.showAlert("Vui lòng nhập đầy đủ trường được yêu cầu", title: "Đặt vé thất bại", buttons: nil)
            return
        }
        
        if !phone.isInt() {
            self.txtPhoneNumber.errorMessage = "Vui lòng nhập số"
            return
        }
        
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CompleteOrderVC") as? CompleteOrderVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func remainingOrder() {
       
    }
}

extension InfoUserVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtEmail {
//            self.txtEmail.errorMessage = ""
//        }
        
        if textField == self.txtFullName {
            self.txtFullName.errorMessage = ""
        }
        
//        if textField == self.txtAddress {
//            self.txtAddress.errorMessage = ""
//        }
        
        if textField == self.txtPhoneNumber {
            self.txtPhoneNumber.errorMessage = ""
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtPhoneNumber {
            if !textField.hasText {
                self.txtPhoneNumber.errorMessage = "Vui lòng nhập số điện thoại"
            } else {
                if let text = textField.text, !text.isInt() {
                    self.txtPhoneNumber.errorMessage = "Vui lòng nhập số"
                }
            }
        }
        
        if textField == self.txtFullName, !textField.hasText {
            self.txtFullName.errorMessage = "Vui lòng nhập Họ và tên"
        }
        
//        if textField == self.txtAddress, !textField.hasText {
//            self.txtAddress.errorMessage = "Vui lòng nhập Địa chỉ"
//        }
//        
//        if textField == self.txtEmail, !textField.hasText {
//            self.txtEmail.errorMessage = "Vui lòng nhập Email"
//        }
    }
}
