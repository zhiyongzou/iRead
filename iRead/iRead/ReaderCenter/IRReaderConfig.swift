//
//  IRReaderConfig.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public enum IRReadPageColorHex: String {
    case HexF8F8F8 = "F8F8F8"
    case HexE9E6D7 = "E9E6D7"
    case Hex373737 = "373737"
    case Hex000000 = "000000"
}

public enum IRTransitionStyle: Int {
    // 横向仿真翻页
    case pageCurl = 0
    // 竖向滚动翻页
    case scroll = 1
}

class IRReaderConfig: NSObject {
    
    static let initOnceReadColorConfig: Bool = {
        pageColorHex = UserDefaults.standard.string(forKey: kReadPageColorHex) ?? IRReadPageColorHex.HexF8F8F8.rawValue
        IRReaderConfig.updateReadColorConfig(pageColorHex: pageColorHex)
        return true
    }()
    
    /// 阅读页面尺寸
    static var pageSzie: CGSize = CGSize.zero
    /// 阅读页面水平边距
    static var horizontalSpacing: CGFloat = 26;
    
    /// 是否跟随系统夜间主题
    static var isFollowSystemTheme: Bool = UserDefaults.standard.bool(forKey: kReadFollowSystemTheme);
    
    /// 文字颜色，默认黑色
    static var textColor: UIColor!
    static var textColorHex: String!
    
    /// 页面颜色，默认白色pageColor
    static var pageColor: UIColor!
    static var pageColorHex: String! {
        willSet {
            UserDefaults.standard.set(newValue, forKey: kReadPageColorHex)
            self.updateReadColorConfig(pageColorHex: newValue)
        }
    }
    
    static var fontName = "PingFangSC-Regular"
    
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
    
    //MARK: - UI Color Theme
    static var secondaryTextColor: UIColor!
    static var separatorColor: UIColor!
    static var bgColor: UIColor!
 
    static func updateReadColorConfig(pageColorHex: String) {
        
        if pageColorHex == IRReadPageColorHex.HexF8F8F8.rawValue {
            textColorHex = "333333"
            separatorColor = UIColor.init(white: 0, alpha: 0.05)
            bgColor = UIColor.hexColor("FFFFFF")
        } else if pageColorHex == IRReadPageColorHex.HexE9E6D7.rawValue {
            textColorHex = "4C3824"
            separatorColor = UIColor.init(white: 0, alpha: 0.05)
            bgColor = UIColor.hexColor("FDF9EA")
        } else if pageColorHex == IRReadPageColorHex.Hex373737.rawValue {
            textColorHex = "DDDDDD"
            separatorColor = UIColor.init(white: 1, alpha: 0.05)
            bgColor = UIColor.hexColor("454545")
        } else  {
            textColorHex = "AAAAAA"
            separatorColor = UIColor.init(white: 1, alpha: 0.05)
            bgColor = UIColor.hexColor("282828")
        }
        
        pageColor = UIColor.hexColor(pageColorHex)
        textColor = UIColor.hexColor(textColorHex)
    }
}

//MARK: - Keys
let kReadTransitionStyle    = "kReadTransitionStyle"
let kReadFollowSystemTheme  = "kReadFollowSystemTheme"
let kReadTextSizeMultiplier = "kReadTextSizeMultiplier"
let kReadPageColorHex       = "kReadPageColorHex"

