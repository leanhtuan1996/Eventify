//
//  EditPhoneNumberVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 12/28/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditPhoneNumberVC: UIViewController {
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewDialog.layer.cornerRadius = 5
        txtPhoneNumber.becomeFirstResponder()
        
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
    }

    @IBAction func btnUpdateClicked(_ sender: Any) {
    }
}
