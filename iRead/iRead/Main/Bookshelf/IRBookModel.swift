//
//  IRBookModel.swift
//  iRead
//
//  Created by zzyong on 2020/12/16.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRBookModel: NSObject {
    
    var coverImage: UIImage?
    var bookName: String
    var progress: CGFloat = 0
    var bookPath: String
    
    init(with bookName: String, path: String) {
        self.bookName = bookName
        self.bookPath = path
        super.init()
    }
    
    class func model(with bookMeta: FRBook, path: String) -> IRBookModel {
        let book = IRBookModel.init(with: bookMeta.title ?? "佚名", path: path)
        if let coverUrl = bookMeta.coverImage?.fullHref {
            book.coverImage = UIImage.init(contentsOfFile: coverUrl)
        }
        return book
    }
}
