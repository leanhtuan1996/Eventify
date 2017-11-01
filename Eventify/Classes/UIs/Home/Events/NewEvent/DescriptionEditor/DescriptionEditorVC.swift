//
//  DescriptionEditorVC.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DescriptionEditorVC: ZSSColorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerImage = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 28))
        
        pickerImage.setImage(#imageLiteral(resourceName: "ZSSimageDevice.png"), for: UIControlState.normal)
        pickerImage.addTarget(self, action: #selector(self.done), for: UIControlEvents.touchUpInside)
        self.addCustomToolbarItem(with: pickerImage)
        
        self.enabledToolbarItems = [ZSSRichTextEditorToolbarBold,ZSSRichTextEditorToolbarItalic,ZSSRichTextEditorToolbarUnderline,ZSSRichTextEditorToolbarJustifyLeft,ZSSRichTextEditorToolbarJustifyCenter,ZSSRichTextEditorToolbarJustifyRight,ZSSRichTextEditorToolbarJustifyFull,ZSSRichTextEditorToolbarH1,ZSSRichTextEditorToolbarH2,ZSSRichTextEditorToolbarH3,ZSSRichTextEditorToolbarH4,ZSSRichTextEditorToolbarH5,ZSSRichTextEditorToolbarH6,ZSSRichTextEditorToolbarTextColor,ZSSRichTextEditorToolbarBackgroundColor,ZSSRichTextEditorToolbarUnorderedList,ZSSRichTextEditorToolbarOrderedList,ZSSRichTextEditorToolbarHorizontalRule,ZSSRichTextEditorToolbarIndent,ZSSRichTextEditorToolbarOutdent,ZSSRichTextEditorToolbarInsertLink,ZSSRichTextEditorToolbarRemoveLink,ZSSRichTextEditorToolbarQuickLink,ZSSRichTextEditorToolbarUndo,ZSSRichTextEditorToolbarRedo,ZSSRichTextEditorToolbarViewSource,ZSSRichTextEditorToolbarParagraph,ZSSRichTextEditorToolbarFonts,ZSSRichTextEditorToolbarRemoveFormat];
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let doneItem = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        self.navigationItem.setRightBarButton(doneItem, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Trở về"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        
        self.shouldShowKeyboard = true
        //self.alwaysShowToolbar = true
        self.placeholder = "Tuỳ chỉnh mô tả chi tiết sự kiện của bạn vào đây"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    override func showInsertImageAlternatePicker() {
        //super.showInsertImageAlternatePicker()
        print("PICKER")
    }
    
    func done() {
        self.navigationController?.popViewController(animated: true)
        
        print(self.getHTML())
    }

}
