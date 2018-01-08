//
//  EditProfileVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var pickerImg = UIImagePickerController()
    var loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        
    }
    
    func setUpUi() {
        imgAvatar.layer.cornerRadius = 50
        
        self.pickerImg.delegate = self
        
        if let photoUrl = UserManager.shared.currentUser?.photoDisplayPath {
            self.imgAvatar.downloadedFrom(link: photoUrl)
            imgCover.downloadedFrom(link: photoUrl, { (image, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.imgCover.image = #imageLiteral(resourceName: "avata")
                    } else {
                        self.imgCover.image = image
                    }
                    self.imgCover.addBlurEffect()
                }
            })
        } else {
            self.imgAvatar.image = #imageLiteral(resourceName: "avata")
            self.imgCover.image = #imageLiteral(resourceName: "avata")
            self.imgCover.addBlurEffect()
        }
        
        self.lblName.text = UserManager.shared.currentUser?.fullName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: true)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdatePhotoClicked(_ sender: Any) {
        self.dismissKeyboard()
        let alert = UIAlertController(title: "Chọn thư viện hoặc camera", message: "Chọn một bức ảnh từ thư viện ảnh hoặc chụp để làm ảnh đại diện cho tài khoản của bạn", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    
    @IBAction func btnUpdatePasswordClicked(_ sender: Any) {
        let vc = EditPasswordVC()
        vc.delegate = self
        
        vc.view.frame = self.view.frame
        self.addChildViewController(vc)
        self.didMove(toParentViewController: vc)
        self.view.addSubview(vc.view)
        
    }
    
    @IBAction func btnUpdateEmailClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdatePhoneClicked(_ sender: Any) {
    }
    
    @IBAction func btnUpdateFullNameClicked(_ sender: Any) {
    }
    
    @IBAction func btnLogOutClicked(_ sender: Any) {
        let loading = UIActivityIndicatorView()
        loading.showLoadingDialog()
        UserManager.shared.setUser(with: nil)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignInView()
        }
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let img = UIImageJPEGRepresentation(image, 0.3) {
                self.updatePhoto(with: img)
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

extension EditProfileVC: UpdateProfilesDelegate {
    func updatePassword(with currentPassword: String, andNewPassword newPassword: String, _ completion: @escaping (_ error: String?) -> Void) -> Void {
        UserServices.shared.updatePassword(withCurrentPw: currentPassword, andNewPw: newPassword) { (error) in
            completion(error)
        }
    }
    func updateFullName(with fullname: String, _ completion: @escaping (_ error: String?) -> Void) -> Void {
        UserServices.shared.updateFullname(withFullname: fullname) { (error) in
            completion(error)
        }
    }
    func updatePhoneNumber(with phoneNumber: String, _ completion: @escaping (_ error: String?) -> Void) -> Void {
        UserServices.shared.updatePhoneNumber(withPhone: phoneNumber) { (error) in
            completion(error)
        }
    }
    func updateEmail(with currentPassword: String, and newEmail: String, _ completion: @escaping (_ error: String?) -> Void) -> Void {
        UserServices.shared.updateEmail(withPassword: currentPassword, withEmail: newEmail) { (error) in
            completion(error)
        }
    }

    func updatePhoto(with imgData: Data) -> Void {
        self.loading.showLoadingDialog()
        UserServices.shared.updatePhotoURL(withImage: imgData, completionHandler: { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
            } else {
                DispatchQueue.main.async {
                    self.imgCover.image = UIImage(data: imgData)
                    self.imgAvatar.image = UIImage(data: imgData)
                }
            }
        })
    }
}
