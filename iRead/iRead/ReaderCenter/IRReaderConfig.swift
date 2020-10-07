//
//  IRReaderConfig.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRReaderConfig: NSObject {
    /// 文字颜色，默认黑色
    static var textColor = UIColor.black
    /// 字体大小
    static var textSize = NSNumber.init(value: 15)
    /// 字体大小倍数
    static var textSizeMultiplier = NSNumber.init(value: 1)
    /// 行距
    static var lineSpacing: CGFloat = 5
    /// 行高倍数
    static var lineHeightMultiple: CGFloat = 1.5
    /// 段落间距
    static var paragraphSpacing: CGFloat = 10
    
}
