//
//  EditPasswordVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/28/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditPasswordVC: UIViewController {
    
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var txtOldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    
    var delegate: UpdateProfilesDelegate?
    var loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDialog.layer.cornerRadius = 5
        
        txtOldPassword.isSecureTextEntry = true
        txtNewPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
        
        txtOldPassword.becomeFirstResponder()
        
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
       removeSubView()
    }
    
    func removeSubView() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func btnUpdateClicked(_ sender: Any) {
        if !self.txtOldPassword.hasText {
            self.txtOldPassword.errorColor = UIColor.red
            self.txtOldPassword.errorMessage = "Vui lòng nhập mật khẩu hiện tại"
        }
        
        if !self.txtNewPassword.hasText {
            self.txtNewPassword.errorColor = UIColor.red
            self.txtNewPassword.errorMessage = "Vui lòng nhập mật khẩu mới"
        }
        
        if !self.txtConfirmPassword.hasText {
            self.txtConfirmPassword.errorColor = UIColor.red
            self.txtConfirmPassword.errorMessage = "Vui lòng nhập xác nhận mật khẩu"
            return
        }
        
        guard let oldPassword = self.txtOldPassword.text, let newPassword = self.txtNewPassword.text, let confirmNewPassword = self.txtConfirmPassword.text else {
            return
        }
        
        if newPassword != confirmNewPassword {
            self.txtConfirmPassword.errorColor = UIColor.red
            self.txtConfirmPassword.errorMessage = "Xác nhận mật khẩu không trùng khớp"
            return
        }
        
        loading.showLoadingDialog(self)
        self.delegate?.updatePassword(with: oldPassword, andNewPassword: newPassword, { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Cập nhật mật khẩu thất bại", buttons: nil)
            } else {
                let returnAction = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.default, handler: { (action) in
                    self.removeSubView()
                })
                
                self.showAlert("Cập nhật mật khẩu thành công", title: "Thông báo", buttons: [returnAction])
            }
        })
    }
}
