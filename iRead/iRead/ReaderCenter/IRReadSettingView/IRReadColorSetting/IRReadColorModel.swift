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

    /// 文字颜色
    var textColor = UIColor.black
    var textColorHex = "000000"
    
    /// 背景颜色
    var pageColor = UIColor.white
    var pageColorHex = "FFFFFF"
    
    /// 选中边框颜色
    var borderColor = UIColor.clear
    
    init(textHex: String, pageHex: String, borderColor: UIColor) {
        self.textColorHex = textHex
        self.pageColorHex = pageHex
        self.textColor = UIColor.hexColor(textHex)
        self.pageColor = UIColor.hexColor(pageHex)
        self.borderColor = borderColor
    }
}
