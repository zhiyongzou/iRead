//
//  IRAboutViewController.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import CommonLib

class IRAboutViewController: IRBaseViewcontroller {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于"
        setupLeftBackBarItem()
        
        let infoDic = Bundle.main.infoDictionary
        let appName = infoDic?["CFBundleName"] ?? ""
        let version = infoDic?["CFBundleShortVersionString"] ?? ""
        
        versionLabel.text = "\(appName) \(version)"
    }
}
