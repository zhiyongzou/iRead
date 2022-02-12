//
//  IRLog.swift
//  CommonLib
//
//  Created by zzyong on 2022/2/5.
//

import Foundation

let logFormatter: DateFormatter = {
    let logFormatter = DateFormatter()
    logFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return logFormatter
}()

public func IRDebugLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    let log = "\(logFormatter.string(from: Date())) [Debug] \((file as NSString).lastPathComponent) \(function) \(line): \(message)"
    print(log)
#endif
}
