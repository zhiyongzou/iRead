//
//  IRReaderConfig.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public enum IRTransitionStyle : Int {
    // 横向仿真翻页
    case pageCurl = 0
    // 竖向滚动翻页
    case scroll = 1
}

class IRReaderConfig: NSObject {
    
    /// 阅读页面尺寸
    static var pageSzie: CGSize = CGSize.zero
    /// 水平边距
    static var horizontalSpacing: CGFloat = 26;
    /// 文字颜色，默认黑色
    static var textColor = UIColor.black
    /// 页面颜色，默认白色
    static var pageColor = UIColor.white
    /// 字体大小
    static var textSize = NSNumber.init(value: 15)
    /// 字体大小倍数
    static var textSizeMultiplier = NSNumber.init(value: 1.1)
    /// 行距
    static var lineSpacing: CGFloat = 5
    /// 行高倍数
    static var lineHeightMultiple = NSNumber.init(value: 1.1)
    /// 段落间距
    static var paragraphSpacing = NSNumber.init(value: 10)
    /// 翻页模式，默认横向仿真翻页
    static var transitionStyle = IRTransitionStyle.scroll
}
