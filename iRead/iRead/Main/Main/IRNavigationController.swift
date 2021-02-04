//
//  IRNavigationController.swift
//  iRead
//
//  Created by zzyong on 2020/2/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 解决 UINavigationController pushViewController 时导航栏黑影问题
        view.backgroundColor = .white
    }
}
