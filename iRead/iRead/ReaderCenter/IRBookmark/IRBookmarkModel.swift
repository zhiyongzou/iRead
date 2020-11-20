//
//  IRBookmarkModel.swift
//  iRead
//
//  Created by zzyong on 2020/11/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookmarkModel: NSObject, NSCoding {

    var markTime: TimeInterval = 0
    var chapterName: String?
    var chapterIdx: Int = 0
    /// 书签文本起始位置
    var textLoction: Int = 0
    
    init(chapterIdx: Int, chapterName: String?, textLoction: Int) {
        super.init()
        self.chapterIdx = chapterIdx
        self.chapterName = chapterName
        self.markTime = NSTimeIntervalSince1970
        self.textLoction = textLoction
    }
    
    required init?(coder: NSCoder) {
        super.init()
        chapterIdx = coder.decodeInteger(forKey: "chapterIdx")
        markTime = coder.decodeDouble(forKey: "markTime")
        textLoction = coder.decodeInteger(forKey: "textLoction")
        if let name = coder.decodeObject(forKey: "chapterName") as? String {
            chapterName = name
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterName, forKey: "chapterName")
        coder.encode(markTime, forKey: "markTime")
        coder.encode(chapterIdx, forKey: "chapterIdx")
        coder.encode(textLoction, forKey: "textLoction")
    }
}
