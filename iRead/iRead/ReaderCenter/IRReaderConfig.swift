//
//  IRReaderConfig.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

public enum IRReadPageColorHex: String {
    case HexF8F8F8 = "F8F8F8"
    case HexE9E6D7 = "E9E6D7"
    case Hex373737 = "373737"
    case Hex000000 = "000000"
}

/// [iOS Fonts]：http://iosfonts.com
/// 中文字体
public enum IRReadZHFontName: String {
    case PingFangSC = "PingFangSC-Regular"
    case STSong     = "STSongti-SC-Regular"
    case STKaitiSC  = "STKaitiSC-Regular"
    case STYuanti   = "STYuanti-SC-Regular"
    
    func displayName() -> String {
        if self.rawValue == IRReadZHFontName.STSong.rawValue {
            return "宋体"
        } else if self.rawValue == IRReadZHFontName.STKaitiSC.rawValue {
            return "楷体"
        } else if self.rawValue == IRReadZHFontName.STYuanti.rawValue {
            return "圆体"
        } else {
            return "苹方"
        }
    }
}

/// 英文字体
public enum IRReadENFontName: String {
    case TimesNewRoman = "TimesNewRomanPSMT"
    case American      = "AmericanTypewriter"
    case Georgia       = "Georgia"
    case Palatino      = "Palatino-Roman"
    
    func displayName() -> String {
        if self.rawValue == IRReadENFontName.American.rawValue {
            return "American"
        } else if self.rawValue == IRReadENFontName.Georgia.rawValue {
            return "Georgia"
        } else if self.rawValue == IRReadENFontName.Palatino.rawValue {
            return "Palatino"
        } else {
            return "Times New Roman"
        }
    }
}

public enum IRTransitionStyle: Int {
    // 横向仿真翻页
    case pageCurl = 0
    // 竖向滚动翻页
    case scroll = 1
}

class IRReaderConfig: NSObject {
    
    /// epub books path
    static let bookUnzipPath: String = {
        let path = IRDocumentDirectoryPath + "/" + "books"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
    
    /// epub books path
    static let bookZipPath: String = {
        let path = IRDocumentDirectoryPath + "/" + "bookZips"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
    
    /// 中文
    static var isChinese = true
    
    /// 阅读页面尺寸
    static var pageSzie: CGSize = CGSize.zero
    /// 阅读页面水平边距
    static var horizontalSpacing: CGFloat = 26;
    
    /// 是否跟随系统夜间主题
    static var isFollowSystemTheme: Bool = UserDefaults.standard.bool(forKey: kReadFollowSystemTheme);
    
    static var linkColorHex = "#536FFA"
    
    /// 文字颜色，默认黑色
    static var textColor: UIColor!
    static var textColorHex: String!
    
    /// 页面颜色，默认白色 pageColor
    static var pageColor: UIColor!
    static var pageColorHex: String! {
        willSet {
            UserDefaults.standard.set(newValue, forKey: kReadPageColorHex)
            self.updateReadColorConfig(pageColorHex: newValue)
        }
    }
    
    static var statusBarStyle: UIStatusBarStyle = .default
    static var barStyle: UIBarStyle = .default
    
    /// 字体类型名
    static var fontName: String {
        get {
            if IRReaderConfig.isChinese {
                return IRReaderConfig.zhFontName.rawValue
            } else {
                return IRReaderConfig.enFontName.rawValue
            }
        }
    }
    
    static var fontDispalyName: String {
        get {
            if IRReaderConfig.isChinese {
                return IRReaderConfig.zhFontName.displayName()
            } else {
                return IRReaderConfig.enFontName.displayName()
            }
        }
    }
    
    static var zhFontName: IRReadZHFontName = {
        let font: IRReadZHFontName = IRReadZHFontName(rawValue: UserDefaults.standard.string(forKey: kReadZHFontName) ?? IRReadZHFontName.PingFangSC.rawValue) ?? IRReadZHFontName.PingFangSC
        return font
    }() {
        willSet {
            UserDefaults.standard.set(newValue.rawValue, forKey: kReadZHFontName)
        }
    }
    
    static var enFontName: IRReadENFontName = {
        let font: IRReadENFontName = IRReadENFontName(rawValue: UserDefaults.standard.string(forKey: kReadENFontName) ?? IRReadENFontName.TimesNewRoman.rawValue) ?? IRReadENFontName.TimesNewRoman
        return font
    }() {
        willSet {
            UserDefaults.standard.set(newValue.rawValue, forKey: kReadENFontName)
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
    
    /// 文本与页码的间距
    static var pageIndexSpacing: CGFloat = 8
    /// 行距
    static var lineSpacing: CGFloat = 2
    /// 行高倍数
    static var lineHeightMultiple: CGFloat = 1.1
    /// 段落间距
    static var paragraphSpacing: CGFloat = 10
    
    /// 翻页模式，默认横向仿真翻页
    static var transitionStyle = IRTransitionStyle(rawValue: UserDefaults.standard.integer(forKey: kReadTransitionStyle)) ?? .pageCurl
    
    //MARK: - UI Color Theme
    static var separatorColor: UIColor!
    static var bgColor: UIColor!
 
    static func updateReadColorConfig(pageColorHex: String) {
        
        if pageColorHex == IRReadPageColorHex.HexF8F8F8.rawValue {
            textColorHex = "333333"
            separatorColor = UIColor.init(white: 0, alpha: 0.08)
            bgColor = UIColor.hexColor("FFFFFF")
            statusBarStyle = .default
            barStyle = .default
        } else if pageColorHex == IRReadPageColorHex.HexE9E6D7.rawValue {
            textColorHex = "4C3824"
            separatorColor = UIColor.init(white: 0, alpha: 0.08)
            bgColor = UIColor.hexColor("FDF9EA")
            statusBarStyle = .default
            barStyle = .default
        } else if pageColorHex == IRReadPageColorHex.Hex373737.rawValue {
            textColorHex = "DDDDDD"
            separatorColor = UIColor.init(white: 1, alpha: 0.08)
            bgColor = UIColor.hexColor("454545")
            statusBarStyle = .lightContent
            barStyle = .black
        } else  {
            textColorHex = "AAAAAA"
            separatorColor = UIColor.init(white: 1, alpha: 0.08)
            bgColor = UIColor.hexColor("282828")
            statusBarStyle = .lightContent
            barStyle = .black
        }
        
        pageColor = UIColor.hexColor(pageColorHex)
        textColor = UIColor.hexColor(textColorHex)
    }
    
    static func initReaderConfig() {
        pageColorHex = UserDefaults.standard.string(forKey: kReadPageColorHex) ?? IRReadPageColorHex.HexF8F8F8.rawValue
        IRReaderConfig.updateReadColorConfig(pageColorHex: pageColorHex)
        
        if UserDefaults.standard.bool(forKey: IRReadZHFontName.STSong.rawValue) {
            IRFontDownload.loadFontWithName(IRReadZHFontName.STSong.rawValue)
        }
        if UserDefaults.standard.bool(forKey: IRReadZHFontName.STKaitiSC.rawValue) {
            IRFontDownload.loadFontWithName(IRReadZHFontName.STKaitiSC.rawValue)
        }
        if UserDefaults.standard.bool(forKey: IRReadZHFontName.STYuanti.rawValue) {
            IRFontDownload.loadFontWithName(IRReadZHFontName.STYuanti.rawValue)
        }
    }
}

//MARK: - Keys
let kReadTransitionStyle    = "kReadTransitionStyle"
let kReadFollowSystemTheme  = "kReadFollowSystemTheme"
let kReadTextSizeMultiplier = "kReadTextSizeMultiplier"
let kReadPageColorHex       = "kReadPageColorHex"
let kReadZHFontName         = "kReadZHFontName"
let kReadENFontName         = "kReadENFontName"

