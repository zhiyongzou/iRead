//
//  IRReaderConfig.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public enum IRReadPageColorHex: String {
    case HexFFFFFF = "FFFFFF"
    case HexC9C196 = "C9C196"
    case Hex505050 = "505050"
    case Hex000000 = "000000"
}

public enum IRTransitionStyle: Int {
    // 横向仿真翻页
    case pageCurl = 0
    // 竖向滚动翻页
    case scroll = 1
}

class IRReaderConfig: NSObject {
    
    /// 阅读页面尺寸
    static var pageSzie: CGSize = CGSize.zero
    /// 阅读页面水平边距
    static var horizontalSpacing: CGFloat = 26;
    
    /// 是否跟随系统夜间主题
    static var isFollowSystemTheme: Bool = UserDefaults.standard.bool(forKey: kReadFollowSystemTheme);
    
    /// 文字颜色，默认黑色
    static var textColor = UIColor.black
    static var textColorHex = "000000" {
        willSet {
            self.textColor = UIColor.hexColor(newValue)
        }
    }
    
    /// 页面颜色，默认白色pageColor
    static var pageColor = UIColor.white
    static var pageColorHex = "FFFFFF" {
        willSet {
            self.pageColor = UIColor.hexColor(newValue)
        }
    }
    
    /// 默认字体大小
    static var defaultTextSize: CGFloat = 15
    static let minTextSizeMultiplier: Int = 6
    static let maxTextSizeMultiplier: Int = 20
    /// 字体大小倍数
    static var textSizeMultiplier: Int = {
        var multiplier = UserDefaults.standard.integer(forKey: kReadTextSizeMultiplier)
        if multiplier == 0 {
            multiplier = 10
        }
        return multiplier
    }()
    
    /// 行距
    static var lineSpacing: CGFloat = 5
    /// 行高倍数
    static var lineHeightMultiple: CGFloat = 1.1
    /// 段落间距
    static var paragraphSpacing: CGFloat = 5
    
    /// 翻页模式，默认横向仿真翻页
    static var transitionStyle = IRTransitionStyle(rawValue: UserDefaults.standard.integer(forKey: kReadTransitionStyle)) ?? .pageCurl
}

//MARK: - Keys
let kReadTransitionStyle    = "kReadTransitionStyle"
let kReadFollowSystemTheme  = "kReadFollowSystemTheme"
let kReadTextSizeMultiplier = "kReadTextSizeMultiplier"

