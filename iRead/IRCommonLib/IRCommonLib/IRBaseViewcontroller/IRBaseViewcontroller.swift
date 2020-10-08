//
//  IRBaseViewcontroller.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/9/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

open class IRBaseViewcontroller: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        IRDebugLog(self)
    }

    open override func viewWillAppear(_ animated: Bool) {
        IRDebugLog(self)
        return super.viewWillAppear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        IRDebugLog(self)
        return super.viewDidDisappear(animated)
    }
    
    open func setupLeftBackBarButton() {
        let backImg = UIImage.init(named: "arrow_back")?.withRenderingMode(.alwaysOriginal)
        let back = UIBarButtonItem.init(image: backImg, style: .plain, target: self, action: #selector(didClickedLeftBackItem(item:)))
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc private func didClickedLeftBackItem(item: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
