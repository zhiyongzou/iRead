//
//  IRBookmarkModel.swift
//  iRead
//
//  Created by zzyong on 2020/11/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookmarkModel: NSObject {

    lazy var chapterName: String = "未知"
    lazy var markTime: TimeInterval = NSTimeIntervalSince1970
    var chapterIdx: Int = 0
    var pageIdx: Int = 0
    var textRange = NSMakeRange(0, 0)
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterName, forKey: "chapterName")
        coder.encode(markTime, forKey: "markTime")
        coder.encode(chapterIdx, forKey: "chapterIdx")
        coder.encode(pageIdx, forKey: "pageIdx")
        coder.encode(textRange, forKey: "textRange")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        chapterIdx = coder.decodeInteger(forKey: "chapterIdx")
        pageIdx =  coder.decodeInteger(forKey: "pageIdx")
        markTime = coder.decodeDouble(forKey: "markTime")
        if let range = coder.decodeObject(forKey: "textRange") as? NSRange {
            textRange = range
        }
        if let name = coder.decodeObject(forKey: "chapterName") as? String {
            chapterName = name
        }
    }
}
