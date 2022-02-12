//
//  IRActivityItemProvider.swift
//  iRead
//
//  Created by zzyong on 2020/12/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import CommonLib
import SSZipArchive
import LinkPresentation

class IRActivityItemProvider: UIActivityItemProvider {

    var title: String?
    var icon: UIImage?
    var shareUrl: URL
    var originalshareUrl: URL!
    var type: UIActivity.ActivityType?
    
    init(shareUrl: URL) {
        originalshareUrl = shareUrl
        // iPhone下 Library/Caches 作为压缩输出路径会有问题，模拟器是OK的。暂时未找原因😅
        self.shareUrl = URL.init(fileURLWithPath: IRFileManager.bookSharePath + shareUrl.lastPathComponent)
        super.init(placeholderItem: self.shareUrl)
    }
    
    override var item: Any {
        if !FileManager.default.fileExists(atPath: shareUrl.path) {
            SSZipArchive.createZipFile(atPath: shareUrl.path, withContentsOfDirectory: originalshareUrl.path)
        }
        return shareUrl
    }
    
    override var activityType: UIActivity.ActivityType? {
        return type
    }
    
    @available(iOS 13.0, *)
    override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.url = shareUrl
        metadata.title = title
        if let icon = icon {
            metadata.iconProvider = NSItemProvider(object: icon)
        }
        return metadata
    }
}
