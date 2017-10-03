//
//  NewEventVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/30/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Gloss


class NewEventVC: UIViewController {

    @IBOutlet weak var imgPicker: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblNameEvent: SkyFloatingLabelTextField!
    @IBOutlet weak var lblByOrganizer: UILabel!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeEnd: UILabel!
    @IBOutlet weak var txtDetailAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var lblEventType: UILabel!
    @IBOutlet weak var lblNumberTickets: UILabel!
    
    var isTimeStartPicked: Bool = false
    var isTimeEndPicked: Bool = false
    var dateTimeSelector: WWCalendarTimeSelector!
    
    override func viewDidLoad(
        ) {
        super.viewDidLoad()
        let tapForLblNumberTickets = UITapGestureRecognizer(target: self, action: #selector(self.showTicketsManager))
        lblNumberTickets.isUserInteractionEnabled = true
        lblNumberTickets.addGestureRecognizer(tapForLblNumberTickets)
        
        let tapForlblTimeStart = UITapGestureRecognizer(target: self, action: #selector(self.showTimeStartCalendarPicker))
        lblTimeStart.isUserInteractionEnabled = true
        lblTimeStart.addGestureRecognizer(tapForlblTimeStart)
        
        let tapForlblTimeEnd = UITapGestureRecognizer(target: self, action: #selector(self.showTimeEndCalendarPicker))
        lblTimeEnd.isUserInteractionEnabled = true
        lblTimeEnd.addGestureRecognizer(tapForlblTimeEnd)
        
        dateTimeSelector = WWCalendarTimeSelector.instantiate()
        dateTimeSelector.delegate = self
        
        lblNameEvent.delegate = self
        txtDetailAddress.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        if let user = UserServices.shared.currentUser {
            lblByOrganizer.text = "Bởi " + (user.fullName ?? "")
        }
        
        lblNumberTickets.text = TicketManager.shared.getTickets().count.toString() + " loại vé"
    }
    

    func showTicketsManager() {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "TicketsManagerVC") as? TicketsManagerVC {
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    func showTimeStartCalendarPicker() {
        isTimeStartPicked = true
        self.tabBarController?.tabBar.isHidden = true
        self.present(dateTimeSelector, animated: true, completion: nil)
    }
    
    func showTimeEndCalendarPicker() {
        isTimeEndPicked = true
        self.tabBarController?.tabBar.isHidden = true
        self.present(dateTimeSelector, animated: true, completion: nil)
    }
    
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        if !lblNameEvent.hasText {
            lblNameEvent.errorMessage = "Trường này là bắt buộc"
        }
        
        if !txtDetailAddress.hasText {
            txtDetailAddress.errorMessage = "Trường này là bắt buộc"
        }
        
        if !isTimeStartPicked {
            lblTimeStart.text = "Vui lòng chọn thời gian bắt đầu"
            lblTimeStart.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
        
        if !isTimeStartPicked {
            lblTimeEnd.text = "Vui lòng chọn thời gian kết thúc"
            lblTimeEnd.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            return
        }
        
        //start add event
        guard let name = lblNameEvent.text, let address = txtDetailAddress.text, let timeStart = lblTimeStart.text, let timeEnd = lblTimeEnd.text else {
            return
        }
                
        let tickets: [TicketObject] = TicketManager.shared.getTickets()
        let event: EventObject = EventObject()
        event.name = name
        event.address = address
        event.tickets = tickets
        event.by = UserServices.shared.currentUser
        event.descriptionEvent = "Không có"
        event.photoURL = "Không có"
        
        if let start = timeStart.toTimeStamp(format: "dd/MM/yyyy HH:mm") {
            print(start)
            event.timeStart = start.toDouble()?.toInt()
        }
        if let end = timeEnd.toTimeStamp(format: "dd/MM/yyyy HH:mm") {
            event.timeEnd = end.toDouble()?.toInt()
        }
        
        
        EventServices.shared.addEvent(withEvent: event) { (error) in
            if let error = error {
                self.showAlert("Thêm mới sự kiện thất bại với lỗi: \(error)", title: "Thêm thất bại", buttons: nil)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
        
    }
    
    @IBAction func btnMoreClicked(_ sender: Any) {
    }

}

extension NewEventVC: WWCalendarTimeSelectorProtocol, UITextFieldDelegate {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        UIView.animate(withDuration: 1) {
            self.tabBarController?.tabBar.isHidden = false
        }
        
        if isTimeStartPicked {
            self.lblTimeStart.text = date.stringFromFormat("dd/MM/yyyy HH:ss")
            lblTimeStart.textColor = UIColor.black
        }
        
        if isTimeEndPicked {
            self.lblTimeEnd.text = date.stringFromFormat("dd/MM/yyyy HH:ss")
            lblTimeEnd.textColor = UIColor.black
            return
        }
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date) {
        UIView.animate(withDuration: 1) {
            self.tabBarController?.tabBar.isHidden = false
        }
        
        if isTimeStartPicked {
            isTimeStartPicked = false
        }
        
        if isTimeEndPicked {
            isTimeEndPicked = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField as? SkyFloatingLabelTextField {
            if !text.hasText {
                text.errorMessage = "Trường này là bắt buộc"
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField as? SkyFloatingLabelTextField {
            text.errorMessage = ""
        }
    }
    
    
    
}
