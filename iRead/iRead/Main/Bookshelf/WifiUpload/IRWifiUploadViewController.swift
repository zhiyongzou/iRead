//
//  IRWifiUploadViewController.swift
//  iRead
//
//  Created by zzyong on 2021/2/4.
//  Copyright © 2021 zzyong. All rights reserved.
//

import IRCommonLib

class IRWifiUploadViewController: IRBaseViewcontroller {

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupLeftBackBarButton()
    }
    
    func commonInit() {
        view.backgroundColor = .white
        title = "WiFi传书"
    }
}
