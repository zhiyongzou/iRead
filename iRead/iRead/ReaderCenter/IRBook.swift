//
//  IRBook.swift
//  iRead
//
//  Created by zzyong on 2020/10/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

protocol IRBookParseDelegate: AnyObject {
    
    func bookBeginParse(_ book: IRBook)
    func book(_ book: IRBook, currentParseProgress progress: Float)
    func bookDidFinishParse(_ book: IRBook)
}

class IRBook: NSObject {

    weak var parseDelegate: IRBookParseDelegate?
    private var bookMeta: FRBook
    var coverImage: UIImage?
    var isFinishParse = false
    var pageCount = 0
    var chapterCount = 0
    lazy var chapterList = [IRBookChapter]()
    var currentReadChapter: IRBookChapter?
    var cureentReadPage: IRBookPage?
    
    var parseQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "book_parse_queue"
        queue.qualityOfService = .background
        return queue
    }()
    
    var insertQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "book_insert_queue"
        queue.qualityOfService = .background
        return queue
    }()
    
    var isChinese: Bool {
        if bookMeta.metadata.language.hasPrefix("zh") {
            return true
        }
        return false
    }
    
    /// 未解析的章节列表
    var originalChapterList: [FRTocReference] {
        get {
            return bookMeta.tableOfContents
        }
    }
    
    var bookName: String? {
        get {
            bookMeta.title
        }
    }
    
    init(withBookMeta bookMeta: FRBook) {
        self.bookMeta = bookMeta
        super.init()
        
        if let coverUrl = bookMeta.coverImage?.fullHref {
            coverImage = UIImage.init(contentsOfFile: coverUrl)
        }
        chapterCount = bookMeta.tableOfContents.count
    }
    
    convenience init(_ bookMeta: FRBook) {
        self.init(withBookMeta: bookMeta)
    }
    
    func didFinishParse(chapterList: [AnyObject], pageCount: Int) {
        
        self.chapterList.removeAll()
        var pageOffset = 0
        for item in chapterList {
            let chapter = item as! IRBookChapter
            chapter.pageOffset = pageOffset
            pageOffset += chapter.pageList.count
            self.chapterList.append(chapter)
            IRDebugLog(chapter.title)
        }
        self.pageCount = pageCount
        isFinishParse = true
        self.parseDelegate?.bookDidFinishParse(self)
        IRDebugLog("book parse finish")
    }
    
    func chapter(withIndex index: Int) -> IRBookChapter {
        
        if isFinishParse {
            return chapterList[index]
        } else {
            return IRBookChapter.init(withTocRefrence: bookMeta.tableOfContents[index], chapterIndex: index)
        }
    }
    
    func chapter(withPageIndex index: Int) -> IRBookChapter {
        
        var chapter: IRBookChapter!
        // 算法后续优化
        for item in chapterList {
            if (index >= item.pageOffset!) && (index <= (item.pageOffset! + item.pageList.count)) {
                chapter = item
                break
            }
        }
        
        return chapter
    }
    
    func parseBookMeta() {
        
        parseQueue.cancelAllOperations()
        insertQueue.cancelAllOperations()
        isFinishParse = false
        self.parseDelegate?.bookBeginParse(self)
        
        var resultList = [AnyObject]()
        var pageCount = 0
        
        // 占位
        for _ in 0..<chapterCount {
            resultList.append(NSNull())
        }
        
        var finishCount = 0
        if chapterList.count > 0 && chapterList.count == self.chapterCount {
            for chapter in chapterList {
                parseQueue.addOperation {
                    if chapter.fontName != IRReaderConfig.fontName {
                        chapter.updateTextFontName(IRReaderConfig.fontName)
                    } else if chapter.textSizeMultiplier != IRReaderConfig.textSizeMultiplier {
                        chapter.updateTextSizeMultiplier(IRReaderConfig.textSizeMultiplier)
                    }
                    IRDebugLog(" \(Thread.current) \(chapter.title ?? "") pageCount: \(chapter.pageList.count)")
                    self.insertQueue.addOperation {
                        pageCount += chapter.pageList.count
                        finishCount += 1
                        resultList[chapter.chapterIdx] = chapter
                        DispatchQueue.main.async {
                            self.parseDelegate?.book(self, currentParseProgress: Float(finishCount) / Float(self.chapterCount))
                        }
                        if finishCount >= self.chapterCount {
                            DispatchQueue.main.async {
                                self.didFinishParse(chapterList: resultList, pageCount: pageCount)
                            }
                        }
                    }
                }
            }
        } else {
            for tocReference: FRTocReference in bookMeta.tableOfContents {
                parseQueue.addOperation {
                    let index = self.bookMeta.tableOfContents.firstIndex(of: tocReference)!
                    let chapter = IRBookChapter.init(withTocRefrence: tocReference, chapterIndex: index)
                    IRDebugLog(" \(Thread.current) \(chapter.title ?? "") pageCount: \(chapter.pageList.count)")
                    self.insertQueue.addOperation {
                        pageCount += chapter.pageList.count
                        finishCount += 1
                        resultList[index] = chapter
                        
                        DispatchQueue.main.async {
                            self.parseDelegate?.book(self, currentParseProgress: Float(finishCount) / Float(self.chapterCount))
                        }
                        if finishCount >= self.chapterCount {
                            DispatchQueue.main.async {
                                self.didFinishParse(chapterList: resultList, pageCount: pageCount)
                            }
                        }
                    }
                }
            }
        }
    }
}
