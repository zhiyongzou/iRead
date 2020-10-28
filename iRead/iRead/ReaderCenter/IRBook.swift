//
//  IRBook.swift
//  iRead
//
//  Created by zzyong on 2020/10/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

class IRBook: NSObject {

    var bookMeta: FRBook
    var chapterList: [IRBookChapter]?
    var currentReadChapter: IRBookChapter?
    var cureentReadPage: IRBookPage?
    var coverImage: UIImage?
    
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
        self.parseBookMeta(bookMeta)
    }
    
    convenience init(_ bookMeta: FRBook) {
        self.init(withBookMeta: bookMeta)
    }
    
    func parseBookMeta(_ bookMeta: FRBook) {
        if let coverUrl = bookMeta.coverImage?.fullHref {
            coverImage = UIImage.init(contentsOfFile: coverUrl)
        }

        
    }
}
