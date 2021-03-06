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
    @IBOutlet weak var lblEventType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNumberTickets: UILabel!
    @IBOutlet weak var lblDescriptionEvent: UILabel!
    var pickerImg = UIImagePickerController()
    
    var isAddressPicked = false
    var isTimeStartPicked: Bool = false
    var dateTimeSelector: WWCalendarTimeSelector!
    
    var descriptionEvent: String?
    
    var newEvent: EventObject = EventObject()
    var address: AddressObject?
    
    let loading = UIActivityIndicatorView()
    
    var timer: Timer?
    
    override func viewDidLoad(
        ) {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
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
        
        let tapForAddressPicker = UITapGestureRecognizer(target: self, action: #selector(self.showMapsPickerVC))
        lblAddress.isUserInteractionEnabled = true
        lblAddress.addGestureRecognizer(tapForAddressPicker)
        
        let tapForDiscriptionEditor = UITapGestureRecognizer(target: self, action: #selector(self.showDescriptionEditor))
        lblDescriptionEvent.isUserInteractionEnabled = true
        lblDescriptionEvent.addGestureRecognizer(tapForDiscriptionEditor)
        
        dateTimeSelector = WWCalendarTimeSelector.instantiate()
        dateTimeSelector.delegate = self
        
        lblNameEvent.delegate = self
        pickerImg.delegate = self
        
        lblNameEvent.returnKeyType = .done
        lblNameEvent.delegate = self
        
        TicketServices.shared.getTickets { (tickets, error) in
            if let tickets = tickets {
                self.lblNumberTickets.text = "\(tickets.count) loại vé"
                self.newEvent.tickets = tickets
                
                self.navigationController?.viewControllers.forEach({ (vc) in
                    if let ticketManager = vc as? TicketsManagerVC {
                        ticketManager.tickets = tickets
                        ticketManager.tblTickets.reloadData()
                    }
                })
                
            } else {
                self.lblNumberTickets.text = "Quản lý vé"
            }
        }
        
        lblByOrganizer.text = "Bởi \(UserManager.shared.currentUser?.fullName ?? "không rõ")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showDescriptionEditor() {
        
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DescriptionEditorVC") as? DescriptionEditorVC {
            //self.tabBarController?.tabBar.isHidden = true
            sb.delegate = self
            self.navigationController?.pushViewController(sb, animated: true)
        }
        
    }
    
    func showTicketsManager() {
        self.dismissKeyboard()
        if let sb = storyboard?.instantiateViewController(withIdentifier: "TicketsManagerVC") as? TicketsManagerVC {
            sb.tickets = self.newEvent.tickets ?? []
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
        self.dismissKeyboard()
        if let sb = storyboard?.instantiateViewController(withIdentifier: "EventTypesVC") as? EventTypesVC {
            self.addChildViewController(sb)
            sb.view.frame = self.view.frame
            self.view.addSubview(sb.view)
            sb.didMove(toParentViewController: self)
            sb.delegate = self
        }
    }
    
    func showOptionPickerImg() {
        self.dismissKeyboard()
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
    
    func showMapsPickerVC() {
        self.dismissKeyboard()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapPickerVC") as? MapPickerVC {
            self.navigationController?.pushViewController(vc, animated: true)
            vc.delegate = self
        }
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        if !lblNameEvent.hasText {
            lblNameEvent.errorMessage = "Trường này là bắt buộc"
        }
        
        if !isAddressPicked {
            lblAddress.text = "Vui lòng chọn vị trí"
            lblAddress.textColor = UIColor.red
        }
        
        //start add event
        guard let name = lblNameEvent.text, let timeStart = lblTimeStart.text, let timeEnd = lblTimeEnd.text, let address = self.address, let descriptionEvent = self.descriptionEvent else {
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
        
        //let tickets: [TicketObject] = TicketManager.shared.getTickets()
        
        newEvent.name = name
        newEvent.address = address
        newEvent.createdBy = UserManager.shared.currentUser
        newEvent.descriptionEvent = descriptionEvent
        newEvent.createdBy = UserManager.shared.currentUser
        
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
        self.loading.showLoadingDialog()
        EventServices.shared.addEvent(withEvent: newEvent) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert("Thêm mới sự kiện thất bại với lỗi: \(error)", title: "Thêm thất bại", buttons: nil)
                return
            }
            
            let button = UIAlertAction(title: "Trở về trang chính", style: UIAlertActionStyle.default, handler: { (btn) in
                
                self.finishedAddEvent()
                
                self.tabBarController?.selectedIndex = 0
            })
            
            self.showAlert("Thêm mới sự kiện thành công", title: "Thêm thành công", buttons: [button])
        }
        self.dismissKeyboard()
    }
    
    func finishedAddEvent() {
        self.imgCover.image = UIImage()
        self.lblDescriptionEvent.text = "Nhấp vào để soạn thảo"
        self.lblNameEvent.text = ""
        self.lblTimeStart.text = "Nhấp vào để chọn ngày"
        self.lblTimeEnd.text = "Nhấp vào để chọn ngày"
        self.lblAddress.text = "Nhấp vào để chọn địa chỉ"
        self.lblEventType.text = "Nhấp vào để chọn loại sự kiện"
        self.newEvent.types = nil
    }
}

extension NewEventVC: WWCalendarTimeSelectorProtocol, UITextFieldDelegate, EventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func discriptionEditor(with text: String, html: String) {
        self.lblDescriptionEvent.text = text.isEmpty ? "Nhấp vào để soạn thảo" : text
        self.descriptionEvent = html.isEmpty ? nil : html
        self.newEvent.descriptionEvent = html.isEmpty ? nil : html
    }
    
    func selectedAddress(with address: AddressObject) {
        self.isAddressPicked = true
        self.address = address
        self.lblAddress.text = address.address
        self.lblAddress.textColor = UIColor.black
    }
    
    func selectedType(with type: TypeObject) {
        self.lblEventType.text = type.name
        
        if self.newEvent.types == nil {
            self.newEvent.types = []
        }
        
        self.newEvent.types?.append(type)
    }
    
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
        return false
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let img = UIImageJPEGRepresentation(image, 0.5) {
                self.imgCover.image = UIImage(data: img)
                
                EventServices.shared.uploadImageCover(data: img, completionHandler: { (path, error) in
                    if let error = error {
                        print("Upload image had been failed: \(error)")
                        return
                    }
                    if let path = path {
                        self.newEvent.photoCoverPath = path
                    }
                })
            }
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.pickerImg.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerImg, animated: true, completion: nil)
        } else {
            self.showAlert("Camera không sẵn có", title: "Lỗi", buttons: nil)
        }
    }
    
    func openGallary() {
        pickerImg.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerImg.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerImg.isEditing = false
        self.present(pickerImg, animated: true, completion: nil)
    }
}
