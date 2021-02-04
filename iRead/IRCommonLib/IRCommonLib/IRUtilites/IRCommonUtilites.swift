//
//  IRCommonUtilites.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/9/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public func IRDebugLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("[Debug] \((file as NSString).lastPathComponent) \(function) \(line): \(message)")
#endif
}

/// App 主题颜色: ff9c00
public let IRAppThemeColor = UIColor.init(red: 1, green: 156/255.0, blue: 0, alpha: 1)

/// App 分割线颜色
public let IRSeparatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)

public let IRScreenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

/// Documents
public let IRDocumentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
/// Library
public let IRLibraryDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
/// Library/Caches
public let IRCachesDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
