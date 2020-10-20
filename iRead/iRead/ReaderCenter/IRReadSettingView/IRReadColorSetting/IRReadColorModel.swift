//
//  IRReadColorModel.swift
//  iRead
//
//  Created by zzyong on 2020/10/15.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

struct IRReadColorModel {
    
    /// 是否选中
    var isSelect = false

    /// 背景颜色
    var pageColor = UIColor.white
    var pageColorHex = "FFFFFF"
    
    /// 选中边框颜色
    var borderColor = UIColor.clear
    
    init(pageHex: String, borderColor: UIColor) {

        self.pageColorHex = pageHex
        self.pageColor = UIColor.hexColor(pageHex)
        self.borderColor = borderColor
    }
}
