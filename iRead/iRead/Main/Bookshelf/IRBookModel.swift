//
//  IRBookModel.swift
//  iRead
//
//  Created by zzyong on 2020/12/16.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import CommonLib

class IRBookModel: NSObject {
    
    var coverImage: UIImage?
    var bookName: String
    var progress: Int = 0
    var bookPath: String
    var authorName: String?
    
    lazy var insertTime: TimeInterval = NSDate().timeIntervalSince1970
    
    var fullPath: String {
        get {
            return IRFileManager.bookUnzipPath + "/" + bookPath
        }
    }
    
    init(with bookName: String, path: String) {
        self.bookName = bookName
        self.bookPath = path
        super.init()
    }
    
    class func model(with bookMeta: FRBook, path: String, imageMaxWidth: CGFloat?) -> IRBookModel {
        let book = IRBookModel.init(with: bookMeta.title ?? "无书名", path: path)
        if let coverUrl = bookMeta.coverImage?.fullHref {
            if let imageMaxWidth = imageMaxWidth {
                book.coverImage = UIImage.init(contentsOfFile: coverUrl)?.scaled(toWidth:imageMaxWidth, scale: 2)
            } else {
                book.coverImage = UIImage.init(contentsOfFile: coverUrl)
            }
        }
        book.authorName = bookMeta.authorName
        return book
    }
}
