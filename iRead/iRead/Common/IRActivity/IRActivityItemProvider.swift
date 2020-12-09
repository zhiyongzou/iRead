//
//  IRActivityItemProvider.swift
//  iRead
//
//  Created by zzyong on 2020/12/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import LinkPresentation

class IRActivityItemProvider: UIActivityItemProvider {

    var title: String?
    var icon: UIImage?
    var shareUrl: URL
    var type: UIActivity.ActivityType?
    
    init(shareUrl: URL) {
        self.shareUrl = shareUrl
        super.init(placeholderItem: shareUrl)
    }
    
    override var item: Any {
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
