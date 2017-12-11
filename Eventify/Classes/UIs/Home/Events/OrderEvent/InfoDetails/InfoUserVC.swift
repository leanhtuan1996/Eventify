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
    var timer = Timer()
    
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
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Trở về", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUi()
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
        
        if let user = UserManager.shared.currentUser {
            txtFullName.text = user.fullName
            txtPhoneNumber.text = user.phoneNumber
            //txtEmail.text = user.email
            //txtAddress.text = user.address
        }
        
        txtFullName.delegate = self
        txtPhoneNumber.delegate = self
        //txtEmail.delegate = self
        //txtAddress.delegate = self
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.remainingTimeOrder), userInfo: nil, repeats: true)
    }
    
    var giay = 60, phut = 4
    func remainingTimeOrder() {
        if giay == 0 {
            giay = 59
            phut -= 1
        }
        
        giay -= 1
        
        DispatchQueue.main.async {
            self.lblTimeRemaining.text = "\(self.phut):\(self.giay)"
        }
        
        
        if giay == 0 && phut == 0 {
            self.timer.invalidate()
            
            let backAction = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.loading.showLoadingDialog(self)
                OrderServices.shared.cancelOrder(completionHandler: { (error) in
                    self.loading.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                })
            })
            
            
            self.showAlert("Bạn đã vượt quá thời gian giới hạn và phiên đặt vé này đã bị kết thúc. Mục đích của việc hạn chế thời gian đặt này để đảm bảo rằng vé bạn đã chọn luôn luôn có sẵn. Chúng tôi xin lỗi vì sự bất tiện này", title: "Whoops!", buttons: [backAction])
        }
    }
    
    @IBAction func btnContinues(_ sender: Any) {
        continues()
    }
    
    func back() {
        
        let backAction = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.loading.showLoadingDialog(self)
            OrderServices.shared.cancelOrder(completionHandler: { (error) in
                self.loading.stopAnimating()
                if let error = error {
                    self.showAlert(error, title: "Oops", buttons: nil)
                    return
                }
                _ = self.navigationController?.popViewController(animated: true)
            })
        })
        
        let keepAction = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.cancel, handler: nil)
        
        self.showAlert("Trở về sẽ mất hết số vé đang mua của bạn", title: "Bạn có muốn trở về không?", buttons: [backAction, keepAction ])
    }
    
    func continues() {
        
        if !self.txtFullName.hasText {
            self.txtFullName.errorMessage = "Vui lòng nhập Họ và Tên"
            return
        }
        
        if !self.txtPhoneNumber.hasText {
            self.txtPhoneNumber.errorMessage = "Vui lòng nhập số điện thoại"
            return
        }
        
        guard let fullName = self.txtFullName.text, let phone = self.txtPhoneNumber.text else {
            self.showAlert("Vui lòng nhập đầy đủ trường được yêu cầu", title: "Đặt vé thất bại", buttons: nil)
            return
        }
        
        if fullName.isEmpty {
            self.txtFullName.errorMessage = "Vui lòng nhập Họ và Tên"
            return
        }
        
        if phone.isEmpty {
            self.txtPhoneNumber.errorMessage = "Vui lòng nhập số điện thoại"
            return
        }
        
        if !phone.isInt() {
            self.txtPhoneNumber.errorMessage = "Vui lòng nhập số"
            return
        }
        
        self.loading.showLoadingDialog(self)
        OrderServices.shared.newOrder(withName: fullName, andPhone: phone) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Mua vé thất bại", buttons: nil)
                return
            }
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteOrderVC") as? CompleteOrderVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
