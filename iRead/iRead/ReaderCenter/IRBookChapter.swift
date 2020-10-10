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
    var pageList: [IRBookPage]?
    /// 章节标题
    var title: String?
    /// 章节索引
    var chapterIdx: Int = 1
    /// 内容
    var content: NSAttributedString?
    
    
    public convenience init(withTocRefrence refrence: FRTocReference, chapterIndex: Int = 1) {
        
        self.init()
        self.title = refrence.title
        self.chapterIdx = chapterIndex
        
        guard let fullHref = refrence.resource?.fullHref else { return }
        let baseUrl = URL.init(fileURLWithPath: fullHref)
        guard let htmlData = try? Data.init(contentsOf: baseUrl) else { return }
        
        let options: [String : Any] = [
            NSBaseURLDocumentOption: baseUrl,
            DTMaxImageSize: NSValue.init(cgSize: IRReaderConfig.pageSzie),
            DTDefaultParagraphSpacing: IRReaderConfig.paragraphSpacing,
            NSTextSizeMultiplierDocumentOption: IRReaderConfig.textSizeMultiplier,
            DTDefaultLineHeightMultiplier: IRReaderConfig.lineHeightMultiple,
            DTDefaultLinkColor: "purple",
            DTDefaultTextColor: IRReaderConfig.textColor,
            DTDefaultFontSize: IRReaderConfig.textSize
        ]
        // as 用法 https://developer.apple.com/swift/blog/?id=23
        let htmlString = NSAttributedString.init(htmlData: htmlData, options: options, documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
        let textLayout = DTCoreTextLayouter.init(attributedString: htmlString)
        let textRect = CGRect.init(origin: CGPoint.zero, size: IRReaderConfig.pageSzie)
        var layoutFrame = textLayout?.layoutFrame(with: textRect, range: NSMakeRange(0, htmlString.length))
        var visibleRange: NSRange! = layoutFrame?.visibleStringRange()
        var pageOffset = visibleRange.location + visibleRange.length
        var pageCount = 1 as Int
        var pageList = [IRBookPage]()
        while pageOffset <= htmlString.length && pageOffset != 0 {
            let pageModel = IRBookPage.bookPage(withPageIdx: pageCount - 1, chapterIdx: chapterIndex)
            pageModel.content = htmlString.attributedSubstring(from: visibleRange)
            layoutFrame = textLayout?.layoutFrame(with: textRect, range: NSMakeRange(pageOffset, htmlString.length - pageOffset))
            visibleRange = layoutFrame?.visibleStringRange()
            if (visibleRange.location == NSNotFound) {
                pageOffset = 0;
            } else {
                pageOffset = visibleRange.location + visibleRange.length;
            }
            pageCount += 1;
            pageList.append(pageModel)
        }
        
        self.pageList = pageList
    }
}
