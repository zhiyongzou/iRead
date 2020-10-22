//
//  IRReadNavigationContentView.swift
//  iRead
//
//  Created by zzyong on 2020/10/22.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRReadNavigationContentView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let targetView = super.hitTest(point, with: event)
        if targetView == self {
            return nil
        }
        return targetView
    }
}
