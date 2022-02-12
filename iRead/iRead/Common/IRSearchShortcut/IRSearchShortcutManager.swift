//
//  IRSearchShortcutManager.swift
//  iRead
//
//  Created by zzyong on 2022/2/9.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

public extension Notification {
    static let IRSearchHistoryChangeNotification = Notification.Name("SearchHistoryChange")
}

class IRSearchShortcutManager: NSObject {
    
    static let kSerachHistory = "kSerachHistory"
    static let shortcutQueue: DispatchQueue = {
        let shortcutQueue = DispatchQueue.init(label: "ir.shortcut.history")
        return shortcutQueue
    }()
    
    static var serachHistory: [String] = {
        guard let history = UserDefaults.standard.array(forKey: kSerachHistory) as? [String] else {
            return []
        }
        return history
    }()
    
    static func saveSearchText(_ text: String) {
        
        if serachHistory.contains(text) {
            return
        }
        
        if serachHistory.count >= 10 {
            serachHistory.removeLast()
        }
        serachHistory.insert(text, at: 0)
        shortcutQueue.async {
            UserDefaults.standard.set(serachHistory, forKey: kSerachHistory)
        }
        NotificationCenter.default.post(name: Notification.IRSearchHistoryChangeNotification, object: nil)
    }
}
