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
}
