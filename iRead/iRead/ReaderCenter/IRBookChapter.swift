//
//  IRBookChapter.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRBookChapter: NSObject {
    /// 章节页列表
    lazy var pages = [IRBookPage]()
    /// 章节标题
    var title: String?
    /// 章节索引
    var chapterIndex = 1
    /// 内容
    var content: NSAttributedString?
    
    
    public convenience init(withTocRefrence refrence: FRTocReference, chapterIndex: Int = 1) {
        
        self.init()
        self.title = refrence.title
        self.chapterIndex = chapterIndex
        
        guard let fullHref = refrence.resource?.fullHref else { return }
        let baseUrl = URL.init(fileURLWithPath: fullHref)
        guard let htmlData = try? Data.init(contentsOf: baseUrl) else { return }
        
        let options: [String : Any] = [
            NSBaseURLDocumentOption: baseUrl,
            DTDefaultParagraphSpacing: IRReaderConfig.paragraphSpacing,
            NSTextSizeMultiplierDocumentOption: IRReaderConfig.textSizeMultiplier,
            DTDefaultLineHeightMultiplier: IRReaderConfig.lineHeightMultiple,
            DTDefaultLinkColor: "purple",
            DTDefaultTextColor: IRReaderConfig.textColor,
            DTDefaultFontSize: IRReaderConfig.textSize
        ]
        // as 用法 https://developer.apple.com/swift/blog/?id=23
        let htmlString = NSAttributedString.init(htmlData: htmlData, options: options, documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
        
        content = htmlString
    }
}
