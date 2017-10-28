//
//  DescriptionEditorVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 10/28/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import RichEditorView

class DescriptionEditorVC: UIViewController {
    
    @IBOutlet weak var editor: RichEditorView!
    var toolbar = RichEditorToolbar()
    var pickerImg = UIImagePickerController()
    var delegate: EventDelegate?
    var pathImg: String?
    let loading = UIActivityIndicatorView()
    var viewImageArray: [UIView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
    }
    
    func setUp() {
        
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        toolbar.options = RichEditorDefaultOption.all
        toolbar.editor = editor
        toolbar.delegate = self
        pickerImg.delegate = self
        self.editor.placeholder = "Chỉnh sửa mô tả chi tiết của sự kiện của bạn"
        self.editor.inputAccessoryView = toolbar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        let doneItem = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        
        self.navigationItem.setRightBarButton(doneItem, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func done() {
        print(editor.contentHTML)
        //delegate?.discriptionEditor(with: editor.text)
        //self.navigationController?.popViewController(animated: true)
    }
    
    func pickingImage() {
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
}

extension DescriptionEditorVC: RichEditorToolbarDelegate {
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        pickingImage()
    }
}

extension DescriptionEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageResized = resizeImage(image: image, newWidth: self.view.bounds.width) {
                if let img = UIImageJPEGRepresentation(imageResized, 0.5) {
                    
                    self.loading.showLoadingDialog(self)
                    EventServices.shared.uploadImageDescriptionEvent(data: img, completionHandler: { (url, error) in
                        self.loading.stopAnimating()
                        print("UP")
                        if let error = error {
                            print("Upload image had been failed: \(error)")
                            return
                        }
                        if let path = url {
                            print(path)
                            
                            self.editor.insertImage(path, alt: "Image Event")
                            
                        }
                    })
                }

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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
