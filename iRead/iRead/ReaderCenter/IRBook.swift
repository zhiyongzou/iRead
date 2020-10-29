//
//  IRBook.swift
//  iRead
//
//  Created by zzyong on 2020/10/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

protocol IRBookParseDelegate: AnyObject {
    
    func bookBeginParse(_: IRBook)
    func book(_: IRBook, currentParseProgress progress: Float)
    func bookDidFinishParse(_: IRBook)
}

class IRBook: NSObject {

    weak var parseDelegate: IRBookParseDelegate?
    var bookMeta: FRBook
    var coverImage: UIImage?
    var isFinishParse = false
    var pageCount = 0
    var chapterCount = 0
    lazy var chapterList = [IRBookChapter]()
    var currentReadChapter: IRBookChapter?
    var cureentReadPage: IRBookPage?
    lazy var insertQueue = DispatchQueue.init(label: "book_insert_queue")
    
    var parseQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "book_parse_queue"
        queue.qualityOfService = .background
        return queue
    }()
    
    var isChinese: Bool {
        if bookMeta.metadata.language.hasPrefix("zh") {
            return true
        }
        return false
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
        
        for item in chapterList {
            if item is IRBookChapter {
                IRDebugLog((item as! IRBookChapter).title)
                self.chapterList.append(item as! IRBookChapter)
            }
        }
        self.pageCount = pageCount
        isFinishParse = true
        self.parseDelegate?.bookDidFinishParse(self)
        IRDebugLog("book parse finish")
    }
    
    func parseBookMeta() {
        
        isFinishParse = false
        self.parseDelegate?.bookBeginParse(self)
        
        var tempList = [AnyObject]()
        var pageCount = 0
        
        // 占位
        for _ in 0..<chapterCount {
            tempList.append(NSNull())
        }
        
        var finishCount = 0
        for tocReference: FRTocReference in bookMeta.tableOfContents {
            parseQueue.addOperation {
                let index = self.bookMeta.tableOfContents.firstIndex(of: tocReference)!
                let chapter = IRBookChapter.init(withTocRefrence: tocReference, chapterIndex: index)
                IRDebugLog(" \(Thread.current) \(chapter.title ?? "") pageCount: \(chapter.pageList!.count)")
                self.insertQueue.sync {
                    pageCount += chapter.pageList?.count ?? 0
                    finishCount += 1
                    tempList[index] = chapter
                    if finishCount >= self.chapterCount {
                        self.didFinishParse(chapterList: tempList, pageCount: pageCount)
                    }
                    self.parseDelegate?.book(self, currentParseProgress: Float(finishCount) / Float(self.chapterCount))
                }
            }
        }
    }
}
