//
//  IRBookChapter.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import DTCoreText
import IRCommonLib

class IRBookChapter: NSObject {
    
    /// 字体
    lazy var fontName = IRReaderConfig.fontName
    /// 文字颜色
    lazy var textColorHex = IRReaderConfig.textColorHex
    /// 文字大小
    lazy var textSizeMultiplier = IRReaderConfig.textSizeMultiplier
    /// 章节页列表
    lazy var pageList = [IRBookPage]()
    /// 章节标题
    var title: String?
    /// 章节索引
    var chapterIdx: Int = 0
    /// 页码偏移
    var pageOffset: Int?
    ///  HTML data
    var htmlData: Data?
    var baseUrl: URL?
    
    
    public convenience init(withTocRefrence refrence: FRTocReference, chapterIndex: Int) {
        
        self.init()
        self.title = refrence.title
        self.chapterIdx = chapterIndex
        
        guard let fullHref = refrence.resource?.fullHref else {
            return
        }
        
        let baseUrl = URL.init(fileURLWithPath: fullHref)
        self.baseUrl = baseUrl
        
        guard let htmlData = try? Data.init(contentsOf: baseUrl) else {
            return
        }
        
        self.htmlData = htmlData
        let htmlString = self.htmlAttributedString(with: htmlData)
        self.pagination(withHtmlAttributedText: htmlString)
    }
    
    func page(at index: Int) -> IRBookPage? {
        
        if index >= pageList.count {
            return pageList.first
        }
        
        if pageOffset != nil {
            let pageModel = pageList[index]
            if let pageOffset = pageOffset {
                pageModel.displayPageIdx = pageOffset + index + 1
            }
            return pageModel
        } else {
            return pageList[index]
        }
    }
    
    func page(in loction: Int) -> IRBookPage? {
        var pageModel: IRBookPage?
        for item in pageList {
            if loction >= item.range.location && loction < item.range.location + item.range.length {
                pageModel = item
                break
            }
        }
        
        if pageModel == nil {
            pageModel = pageList.first
        }
        
        return pageModel
    }
    
    func htmlAttributedString(with htmlData: Data) -> NSMutableAttributedString {
        
        guard let baseUrl = self.baseUrl else { return NSMutableAttributedString() }
        let options: [String : Any] = [
            NSBaseURLDocumentOption: baseUrl,
            DTDefaultFontName: IRReaderConfig.fontName,
            DTMaxImageSize: IRReaderConfig.pageSzie,
            NSTextSizeMultiplierDocumentOption: (CGFloat(textSizeMultiplier) / 10.0),
            DTDefaultLineHeightMultiplier: IRReaderConfig.lineHeightMultiple,
            DTDefaultLinkColor: IRReaderConfig.linkColorHex,
            DTDefaultTextColor: UIColor.hexColor(textColorHex!),
            DTDefaultFontSize: IRReaderConfig.defaultTextSize
        ]
        // as 用法 https://developer.apple.com/swift/blog/?id=23
        // as? 或 as! 向下转到它的子类
        let htmlString = NSAttributedString.init(htmlData: htmlData, options: options, documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
        let tempHtmlString = htmlString.mutableCopy() as? NSMutableAttributedString
        
        tempHtmlString?.enumerateAttributes(in: NSMakeRange(0, htmlString.length), options: [.longestEffectiveRangeNotRequired]) { (value: [NSAttributedString.Key : Any], range, stop) in
            
            // 段落样式调整
            if let paragraphStyle = value[.paragraphStyle] as? NSParagraphStyle {
                let mutableStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                mutableStyle.paragraphSpacing = IRReaderConfig.paragraphSpacing
                mutableStyle.lineSpacing = IRReaderConfig.lineSpacing
                htmlString.addAttribute(.paragraphStyle, value: mutableStyle, range: range)
            }
            
            // 字体调整
            if let value = value[.font] as? UIFont {
                if value.fontName != IRReaderConfig.fontName {
                    let font = UIFont.init(name: IRReaderConfig.fontName, size: value.pointSize) ?? value
                    htmlString.addAttribute(.font, value: font, range: range)
                }
            }
        }
        return htmlString
    }
    
    func updateTextFontName(_ fontName: String) {
        self.fontName = fontName
        
        guard let htmlData = self.htmlData else {
            return
        }
        let htmlString = self.htmlAttributedString(with: htmlData)
        let tempHtmlString = htmlString.mutableCopy() as? NSMutableAttributedString
        tempHtmlString?.enumerateAttribute(.font, in: NSMakeRange(0, htmlString.length), options: [.longestEffectiveRangeNotRequired], using: { (value, range, stop) in
            if let value = value as? UIFont {
                let font = UIFont.init(name: fontName, size: value.pointSize) ?? value
                htmlString.addAttribute(.font, value: font, range: range)
            }
        })
        self.pagination(withHtmlAttributedText: htmlString)
    }
    
    func updateTextColorHex(_ textColorHex: String) {
        self.textColorHex = textColorHex
        let textColor = UIColor.hexColor(textColorHex)
        for pageModel in pageList {
            pageModel.updateTextColor(textColor)
        }
    }
    
    func updateTextSizeMultiplier(_ textSizeMultiplier: Int) {
        self.textSizeMultiplier = textSizeMultiplier
        
        guard let htmlData = self.htmlData else {
            return
        }
        let htmlString = self.htmlAttributedString(with: htmlData)
        self.pagination(withHtmlAttributedText: htmlString)
    }
    
    func pagination(withHtmlAttributedText htmlString: NSMutableAttributedString) {
        
        if htmlString.length == 0 {
            // 空白章节
            let pageModel = IRBookPage.bookPage(withPageIdx: 0, chapterIdx: self.chapterIdx)
            pageModel.textColorHex = textColorHex
            self.pageList = [pageModel]
            return
        }
        
        let textLayout = DTCoreTextLayouter.init(attributedString: htmlString)
        let textRect = CGRect.init(origin: CGPoint.zero, size: IRReaderConfig.pageSzie)
        var layoutFrame = textLayout?.layoutFrame(with: textRect, range: NSMakeRange(0, htmlString.length))
        var visibleRange: NSRange! = layoutFrame?.visibleStringRange()
        if visibleRange == NSRange(location: 0, length: 0) {
            let pageModel = IRBookPage.bookPage(withPageIdx: 0, chapterIdx: self.chapterIdx)
            pageModel.textColorHex = textColorHex
            self.pageList = [pageModel]
            return
        }
        var pageOffset = visibleRange.location + visibleRange.length
        var pageCount: Int = 0
        var pageList = [IRBookPage]()
        while pageOffset <= htmlString.length && pageOffset != 0 {
            
            let content = htmlString.attributedSubstring(from: visibleRange)
            let textContent = content.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            // 空白页判断
            if textContent.count > 0 {
                let pageModel = IRBookPage.bookPage(withPageIdx: pageCount, chapterIdx: self.chapterIdx)
                pageModel.content = content
                pageModel.chapterName = title
                pageModel.range = visibleRange
                pageModel.textColorHex = textColorHex
                pageCount += 1;
                pageList.append(pageModel)
            }
            
            // 首行缩进处理
            var nextPageNeedFirstLineHeadIndent = true
            if let paragraphRanges = layoutFrame?.paragraphRanges {
                for rangeValue in paragraphRanges {
                    let range = (rangeValue as! NSValue).rangeValue
                    if (pageOffset > range.location && pageOffset < (range.location + range.length)) {
                        nextPageNeedFirstLineHeadIndent = false
                        break
                    }
                }
            }
            
            layoutFrame = textLayout?.layoutFrame(with: textRect, range: NSMakeRange(pageOffset, htmlString.length - pageOffset))
            if layoutFrame == nil {
                break
            }
            
            if !nextPageNeedFirstLineHeadIndent {
                let firstLine: DTCoreTextLayoutLine = layoutFrame?.lines.first as! DTCoreTextLayoutLine
                let firstLineRange = firstLine.stringRange()
                let firstLineAtt = htmlString.attributedSubstring(from: firstLineRange)
                let originalStyle = firstLineAtt.attribute(.paragraphStyle, at: 0, effectiveRange: nil)
                if (originalStyle != nil) {
                    let firstLineStyle: NSMutableParagraphStyle = (originalStyle as! NSParagraphStyle).mutableCopy() as! NSMutableParagraphStyle
                    firstLineStyle.firstLineHeadIndent = firstLineStyle.headIndent;
                    htmlString.addAttributes([.paragraphStyle: firstLineStyle], range: firstLineRange)
                }
            }
            
            visibleRange = layoutFrame?.visibleStringRange()
            if (visibleRange.location == NSNotFound) {
                pageOffset = 0;
            } else {
                pageOffset = visibleRange.location + visibleRange.length;
            }
        }
        
        self.pageList = pageList
    }
}
