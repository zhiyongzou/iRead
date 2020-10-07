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

/// App 主题颜色
public let IRAppThemeColor = UIColor.init(red: 1, green: 156/255.0, blue: 0, alpha: 1)

