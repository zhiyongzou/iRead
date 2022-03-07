//
//  IRPasteboardManager.swift
//  iRead
//
//  Created by zzyong on 2022/3/6.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import CommonLib

class IRPasteboardManager: NSObject {
    
    static var shareInstance = IRPasteboardManager()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPasteboardContentChanged(notification:)),
                                               name: UIPasteboard.changedNotification,
                                               object: nil)
    }
    
    var queue: DispatchQueue = {
        let queue = DispatchQueue.init(label: "paste.board.queue")
        return queue
    }()
    
    @objc func onPasteboardContentChanged(notification: Notification) {
        guard let _ = UIPasteboard.general.string else { return }
        IRDebugLog(UIPasteboard.general.string!)
        self.downloadFileWithPasteboardContentIfNeeded()
    }
    
    func downloadFileWithPasteboardContentIfNeeded() {
        queue.async {
            guard let pasteString = UIPasteboard.general.string else { return }
            DispatchQueue.main.async {
                if IRDownloadManager.shouldDownloadFileWithUrl(pasteString) {
                    UIPasteboard.general.string = nil
                }
            }
            
        }
    }
    
}
