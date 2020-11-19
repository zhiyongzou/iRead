//
//  IRReadingRecordModel.swift
//  iRead
//
//  Created by zzyong on 2020/11/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

import Foundation

class IRReadingRecordModel: NSObject ,NSCoding {
    
    var chapterIdx: Int = 0
    var pageIdx: Int = 0
    var textRange = NSMakeRange(0, 0)
    
    
    init(_ chapterIdx: Int, _ pageIdx: Int, _ range: NSRange) {
        super.init()
        self.chapterIdx = chapterIdx
        self.pageIdx = pageIdx
        self.textRange = range
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterIdx, forKey: "chapterIdx")
        coder.encode(pageIdx, forKey: "pageIdx")
        coder.encode(textRange, forKey: "textRange")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        chapterIdx = coder.decodeInteger(forKey: "chapterIdx")
        pageIdx =  coder.decodeInteger(forKey: "pageIdx")
        if let range = coder.decodeObject(forKey: "textRange") as? NSRange {
            textRange = range
        }
    }
}

