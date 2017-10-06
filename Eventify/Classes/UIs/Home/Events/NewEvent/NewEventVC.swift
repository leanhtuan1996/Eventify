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
    @IBOutlet weak var txtDescriptionEvent: SkyFloatingLabelTextField!
    var pickerImg = UIImagePickerController()

    
    var isTimeStartPicked: Bool = false
    var dateTimeSelector: WWCalendarTimeSelector!
    
    var newEvent: EventObject = EventObject()
    
    let loading = UIActivityIndicatorView()
    
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
        
        let tapForlblEventType = UITapGestureRecognizer(target: self, action: #selector(self.showPopupEventTypes))
        lblEventType.isUserInteractionEnabled = true
        lblEventType.addGestureRecognizer(tapForlblEventType)
        
        let tapForImgPicker = UITapGestureRecognizer(target: self, action: #selector(self.showOptionPickerImg))
        imgPicker.isUserInteractionEnabled = true
        imgPicker.addGestureRecognizer(tapForImgPicker)
        
        dateTimeSelector = WWCalendarTimeSelector.instantiate()
        dateTimeSelector.delegate = self
        
        lblNameEvent.delegate = self
        txtDetailAddress.delegate = self
        
        pickerImg.delegate = self
        
        lblNameEvent.returnKeyType = .done
        lblNameEvent.delegate = self
        
        txtDetailAddress.returnKeyType = .done
        txtDetailAddress.delegate = self
        
        txtDescriptionEvent.returnKeyType = .done
        txtDescriptionEvent.delegate = self
        
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
        isTimeStartPicked = false
        self.tabBarController?.tabBar.isHidden = true
        self.present(dateTimeSelector, animated: true, completion: nil)
    }
    
    func showPopupEventTypes() {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "EventTypesVC") as? EventTypesVC {
            self.addChildViewController(sb)
            sb.view.frame = self.view.frame
            self.view.addSubview(sb.view)
            sb.didMove(toParentViewController: self)
            sb.delegate = self
        }
    }
    
    func showOptionPickerImg() {
        let alert = UIAlertController(title: "Chọn thư viện hoặc camera", message: "Chọn một bức ảnh từ thư viện ảnh hoặc chụp để làm ảnh bìa cho sự kiện của bạn", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Trở về", style: UIAlertActionStyle.cancel, handler: nil)
        let libraryAction = UIAlertAction(title: "Thư viện ảnh", style: UIAlertActionStyle.default) { (btn) in
            self.openGallary()
        }
        
        let cameraAction = UIAlertAction(title: "Máy ảnh", style: UIAlertActionStyle.default) { (btn) in
            self.openCamera()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        if !lblNameEvent.hasText {
            lblNameEvent.errorMessage = "Trường này là bắt buộc"
        }
        
        if !txtDetailAddress.hasText {
            txtDetailAddress.errorMessage = "Trường này là bắt buộc"
            return
        }
        
        //start add event
        guard let name = lblNameEvent.text, let address = txtDetailAddress.text, let timeStart = lblTimeStart.text, let timeEnd = lblTimeEnd.text else {
            return
        }
        
        if !timeStart.isDate() {
            lblTimeStart.text = "Vui lòng chọn ngày bắt đầu"
            lblTimeStart.textColor = UIColor.red
        }
        
        if !timeEnd.isDate() {
            lblTimeEnd.text = "Vui lòng chọn ngày kết thúc"
            lblTimeEnd.textColor = UIColor.red
            return
        }
                
        let tickets: [TicketObject] = TicketManager.shared.getTickets()
        
        newEvent.name = name
        newEvent.address = address
        newEvent.tickets = tickets
        newEvent.by = UserServices.shared.currentUser
        newEvent.descriptionEvent = txtDescriptionEvent.text
        newEvent.photoURL = "Không có"
        
        if let start = timeStart.toTimeStamp(format: "dd/MM/yyyy HH:mm") {
            newEvent.timeStart = start.toDouble()?.toInt()
        }
        if let end = timeEnd.toTimeStamp(format: "dd/MM/yyyy HH:mm") {
            newEvent.timeEnd = end.toDouble()?.toInt()
        }
        
        if newEvent.types?.count == 0 {
            self.showAlert("Vui lòng chọn loại sự kiện", title: "Thông báo", buttons: nil)
            return
        }
        
        self.loading.showLoadingDialog(self)
        EventServices.shared.addEvent(withEvent: self.newEvent) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert("Thêm mới sự kiện thất bại với lỗi: \(error)", title: "Thêm thất bại", buttons: nil)
                return
            }
            
            let button = UIAlertAction(title: "Trở về trang chính", style: UIAlertActionStyle.default, handler: { (btn) in
                self.tabBarController?.selectedIndex = 0
            })
            
            self.showAlert("Thêm mới sự kiện thành công", title: "Thêm thành công", buttons: [button])
            
        }
    }
}

extension NewEventVC: WWCalendarTimeSelectorProtocol, UITextFieldDelegate, SelectPropertyEventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        UIView.animate(withDuration: 1) {
            self.tabBarController?.tabBar.isHidden = false
        }
        
        if isTimeStartPicked {
            self.lblTimeStart.text = date.stringFromFormat("dd/MM/yyyy HH:ss")
            lblTimeStart.textColor = UIColor.black
        } else {
            self.lblTimeEnd.text = date.stringFromFormat("dd/MM/yyyy HH:ss")
            lblTimeEnd.textColor = UIColor.black
        }
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date) {
        UIView.animate(withDuration: 1) {
            self.tabBarController?.tabBar.isHidden = false
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func selectedType(with type: EventTypeObject) {
        self.lblEventType.text = type.name
        
        if self.newEvent.types == nil {
            self.newEvent.types = []
        }
        
        self.newEvent.types?.append(type)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            self.imgCover.image = editedImage
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            self.imgCover.image = orginalImage
        } 
        else { print ("error") }
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerImg.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerImg, animated: true, completion: { 
                
            })
        
        } else {
            self.showAlert("Camera không sẵn có", title: "Lỗi", buttons: nil)
        }
    }
    
    func openGallary() {
        pickerImg.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerImg.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerImg.isEditing = true
        self.present(pickerImg, animated: true) { 
            
        }
    }
}

protocol SelectPropertyEventDelegate {
    func selectedType(with type: EventTypeObject) -> Void
}
