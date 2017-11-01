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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let doneItem = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        self.navigationItem.setRightBarButton(doneItem, animated: true)
        self.shouldShowKeyboard = false
        //self.alwaysShowToolbar = true
        self.placeholder = "Tuỳ chỉnh mô tả chi tiết sự kiện của bạn vào đây"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    func done() {
        self.navigationController?.popViewController(animated: true)
        
        print(self.getHTML())
    }

}
